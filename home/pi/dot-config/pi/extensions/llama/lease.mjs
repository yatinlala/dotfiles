import net from 'node:net';
import { spawn } from 'node:child_process';
import { open } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import { setTimeout as sleep } from 'node:timers/promises';
import { endpoint, fingerprint } from './core.mjs';

function connect(path) {
  return new Promise((resolve, reject) => {
    const socket = net.createConnection(path);
    const timer = setTimeout(() => { socket.destroy(); reject(new Error('Supervisor connection timed out')); }, 1000);
    socket.once('error', error => { clearTimeout(timer); socket.destroy(); reject(error); });
    socket.once('connect', () => { clearTimeout(timer); resolve(socket); });
  });
}
async function acquireOnce(config, onLost) {
  const address = await endpoint(config);
  let socket;
  try { socket = await connect(address.path); }
  catch (error) {
    if (!['ECONNREFUSED', 'ENOENT'].includes(error.code)) throw error;
    const log = await open(address.log, 'a', 0o600);
    try {
      const broker = spawn(process.release?.name === 'node' ? process.execPath : 'node',
        [fileURLToPath(new URL('./broker.mjs', import.meta.url))], {
          detached: true, stdio: ['ignore', log.fd, log.fd],
          env: { ...process.env, PI_LLAMA_BROKER_CONFIG: JSON.stringify(config) },
        });
      let launchError;
      broker.on('error', error => { launchError = error; });
      broker.unref();
      for (let i = 0; i < 60; i++) {
        if (launchError) throw launchError;
        try { socket = await connect(address.path); break; }
        catch (error) { if (!['ECONNREFUSED', 'ENOENT'].includes(error.code)) throw error; }
        await sleep(50);
      }
    } finally { await log.close(); }
  }
  if (!socket) throw new Error(`Supervisor did not start; see ${address.log}`);
  let closed = false;
  let isReady = false;
  let lostMessage = 'Lost the llama.cpp supervisor connection; run /llama to reconnect';
  // The socket keeps the lease, not the Pi process itself, alive.
  socket.unref();
  const lease = await new Promise((resolve, reject) => {
    let buffer = '';
    const timer = setTimeout(() => {
      socket.destroy(); reject(new Error(`Router startup timed out; see ${address.log}`));
    }, config.startupMs + 5000);
    socket.on('error', error => { lostMessage = error.message; if (!isReady) { clearTimeout(timer); reject(error); } });
    socket.on('close', () => {
      clearTimeout(timer);
      if (!isReady) reject(new Error(lostMessage));
      else if (!closed) onLost(lostMessage);
    });
    socket.on('data', data => {
      buffer += data.toString();
      if (buffer.length > 16384) { socket.destroy(); return; }
      while (buffer.includes('\n')) {
        const index = buffer.indexOf('\n');
        let message;
        try { message = JSON.parse(buffer.slice(0, index)); }
        catch { socket.destroy(); return; }
        buffer = buffer.slice(index + 1);
        if (message.error) {
          lostMessage = message.error;
          if (!isReady) { clearTimeout(timer); socket.destroy(); reject(new Error(message.error)); }
        } else if (message.ready && !isReady) {
          clearTimeout(timer); isReady = true;
          resolve({
            owned: message.owned, log: message.log,
            get closed() { return closed || socket.destroyed; },
            close() { closed = true; socket.destroy(); },
          });
        }
      }
    });
    socket.write(JSON.stringify({ token: address.token, fingerprint: fingerprint(config) }) + '\n');
  });
  return lease;
}

export async function acquire(config, onLost = () => {}) {
  for (let attempt = 0; attempt < 20; attempt++) {
    try { return await acquireOnce(config, onLost); }
    catch (error) {
      if (error.message !== 'LLAMA_RETRY_SHUTDOWN' || attempt === 19) throw error;
      await sleep(300);
    }
  }
}
