// Separate process: owns the router, while each attached Pi holds a socket lease.
import net from 'node:net';
import { spawn } from 'node:child_process';
import { access } from 'node:fs/promises';
import { setTimeout as sleep } from 'node:timers/promises';
import { endpoint, discover, fingerprint, refused } from './core.mjs';

const config = JSON.parse(process.env.PI_LLAMA_BROKER_CONFIG);
delete process.env.PI_LLAMA_BROKER_CONFIG;
const address = await endpoint(config);
const peers = new Set();
let child;
let childError;
let ready;
let stopping = false;
let idleTimer;
const send = (socket, message) => { if (!socket.destroyed) socket.write(JSON.stringify(message) + '\n'); };
const groupSignal = signal => {
  if (!child?.pid) return;
  try { process.kill(-child.pid, signal); } catch (error) { if (error.code !== 'ESRCH') throw error; }
};
async function stop() {
  if (stopping) return;
  stopping = true;
  clearTimeout(idleTimer);
  for (const socket of peers) socket.destroy();
  if (child?.pid) {
    groupSignal('SIGTERM');
    for (let i = 0; i < 50 && child.exitCode === null && child.signalCode === null; i++) await sleep(100);
    // Also remove any remaining children in the owned process group.
    groupSignal('SIGKILL');
  }
  server.close();
  process.exit(0);
}
function scheduleIdle() {
  clearTimeout(idleTimer);
  if (!peers.size) idleTimer = setTimeout(() => { void stop(); }, config.graceMs);
}
async function ensureRouter() {
  try {
    const result = await discover(config);
    if (!result.autoload) throw new Error('Existing router has autoload disabled; restart it with --models-autoload');
    return { owned: false };
  } catch (error) {
    // Never spawn over an occupied, unresponsive, incompatible, or authenticated endpoint.
    if (!refused(error)) throw error;
  }
  const url = new URL(config.url);
  if (url.protocol !== 'http:' || !['127.0.0.1', '[::1]'].includes(url.hostname) || url.pathname !== '/') {
    throw new Error('Automatic startup is only allowed for a local loopback HTTP router; start remote servers yourself');
  }
  await access(config.modelsDir);
  const args = ['--models-dir', config.modelsDir, '--models-autoload', '--host', url.hostname.replace(/[\[\]]/g, ''),
    '--port', url.port || '80', '--jinja', '-ngl', 'all', '-c', String(config.context)];
  // A missing preset is fine; errors other than ENOENT are not silently ignored.
  try { await access(config.preset); args.push('--models-preset', config.preset); }
  catch (error) { if (error.code !== 'ENOENT') throw error; }
  if (stopping) throw new Error('Supervisor is shutting down');
  child = spawn(config.binary, args, {
    detached: true, stdio: ['ignore', 'inherit', 'inherit'],
    env: { ...process.env, LLAMA_API_KEY: config.apiKey },
  });
  child.on('error', error => { childError = error; });
  child.on('exit', (code, signal) => {
    if (stopping) return;
    childError = new Error(`Managed llama-server exited (${signal || code}); see ${address.log}`);
    for (const socket of peers) { send(socket, { error: childError.message }); socket.end(); }
    scheduleIdle();
  });
  const deadline = Date.now() + config.startupMs;
  while (Date.now() < deadline) {
    if (childError) throw childError;
    try {
      const result = await discover(config);
      if (!result.autoload) throw new Error('Managed router did not enable autoload');
      if (childError) throw childError;
      return { owned: true };
    } catch (error) {
      if (!refused(error)) throw error;
    }
    await sleep(100);
  }
  throw new Error(`Router startup timed out; see ${address.log}`);
}
const server = net.createServer(socket => {
  if (stopping) { send(socket, { error: 'LLAMA_RETRY_SHUTDOWN' }); socket.end(); return; }
  let buffer = '';
  let attached = false;
  socket.on('error', () => {});
  socket.setTimeout(2000, () => { if (!attached) socket.destroy(); });
  socket.on('data', async data => {
    if (attached) return;
    buffer += data.toString();
    if (buffer.length > 4096) { socket.destroy(); return; }
    if (!buffer.includes('\n')) return;
    try {
      const hello = JSON.parse(buffer.slice(0, buffer.indexOf('\n')));
      if (hello.token !== address.token || hello.fingerprint !== fingerprint(config)) {
        throw new Error('Another Pi session manages this endpoint with different configuration');
      }
      attached = true;
      socket.setTimeout(0);
      peers.add(socket);
      clearTimeout(idleTimer);
      ready ??= ensureRouter(); // single startup shared by all simultaneous clients
      const result = await ready;
      if (!socket.destroyed) send(socket, { ready: true, ...result, log: address.log });
    } catch (error) {
      send(socket, { error: error.message }); socket.end();
    }
  });
  socket.on('close', () => { peers.delete(socket); scheduleIdle(); });
});
server.on('error', error => {
  // Another session's supervisor won the kernel's atomic bind race.
  if (error.code === 'EADDRINUSE') process.exit(0);
  console.error(error); process.exit(1);
});
server.listen(address.path, () => {
  // Don't persist if the initiating Pi died before connecting.
  idleTimer = setTimeout(() => { void stop(); }, 5000);
});
for (const signal of ['SIGTERM', 'SIGINT', 'SIGHUP']) process.on(signal, () => { void stop(); });
