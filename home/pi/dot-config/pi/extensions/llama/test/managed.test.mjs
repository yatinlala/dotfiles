import { test } from 'node:test';
import assert from 'node:assert/strict';
import net from 'node:net';
import http from 'node:http';
import { spawn } from 'node:child_process';
import { mkdtemp, mkdir, readFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { setTimeout as sleep } from 'node:timers/promises';
import { acquire } from '../lease.mjs';
import { configuration, discover, request, selectable, contextFrom, toPiModel } from '../core.mjs';
import extension from '../index.ts';
const fake = fileURLToPath(new URL('./fake-router.mjs', import.meta.url));
async function port() {
  const server = net.createServer();
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  const result = server.address().port;
  await new Promise(resolve => server.close(resolve)); return result;
}
async function fixture(t) {
  const root = await mkdtemp(join(tmpdir(), 'pi-llama-test-'));
  await mkdir(join(root, 'models'));
  const config = { url: `http://127.0.0.1:${await port()}`, apiKey: '', binary: fake, modelsDir: join(root, 'models'),
    preset: join(root, 'missing.ini'), context: 8192, runtimeDir: join(root, 'runtime'), startupMs: 3000, graceMs: 100 };
  t.after(async () => { await sleep(300); await rm(root, { recursive: true, force: true }); });
  return config;
}
async function until(fn, timeout = 5000) {
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) { if (await fn()) return; await sleep(50); }
  throw new Error('Condition timed out');
}
const alive = pid => { try { process.kill(pid, 0); return true; } catch { return false; } };
async function startExternal(t, c, flags = []) {
  const p = spawn(fake, ['--models-dir', c.modelsDir, '--port', new URL(c.url).port, ...flags], { stdio: 'ignore' });
  t.after(() => p.kill());
  await until(async () => { try { await request(c, '/models'); return true; } catch { return false; } });
  return p;
}

test('configuration defaults and URL normalization', () => {
  assert.equal(configuration({}).url, 'http://127.0.0.1:8081');
  assert.equal(configuration({ LLAMA_BASE_URL: 'http://localhost:8081/v1/' }).url, 'http://127.0.0.1:8081');
  assert.throws(() => configuration({ LLAMA_BASE_URL: 'http://user:secret@localhost:8081' }));
});
test('catalog accepts discovered models and excludes failures/decision-only via extension', () => {
  const model = { status: { value: 'unloaded' }, source: 'models_dir' };
  assert.equal(selectable(model, true), true);
  assert.equal(selectable(model, false), false);
  assert.equal(selectable({ ...model, source: 'preset' }, true), true);
  assert.equal(selectable({ ...model, status: { value: 'unloaded', failed: true } }, true), false);
  assert.equal(selectable({ status: { value: 'sleeping' } }, false), true);
});
test('context uses actual runtime arguments, never training context', () => {
  const model = { id: 'test', context_length: 262144, meta: { n_ctx_train: 262144 }, status: { args: ['--ctx-size', '8192'] } };
  assert.equal(contextFrom(model), 8192);
  assert.equal(contextFrom({ status: {}, context_length: 262144 }), 8192);
  assert.equal(toPiModel(model, { chat_template: 'enable_thinking' }, 8192).reasoning, true);
});
test('simultaneous sessions share one router; last lease stops it', async t => {
  const c = await fixture(t);
  const leases = await Promise.all(Array.from({ length: 5 }, () => acquire(c)));
  t.after(() => leases.forEach(l => l.close()));
  assert.ok(leases.every(l => l.owned));
  assert.equal((await readFile(join(c.modelsDir, 'starts'), 'utf8')).trim(), 'start');
  const pid = Number(await readFile(join(c.modelsDir, 'router.pid'), 'utf8'));
  leases.slice(0, -1).forEach(l => l.close());
  await sleep(350);
  assert.equal(alive(pid), true);
  assert.equal((await discover(c)).models.length, 1);
  leases.at(-1).close();
  await until(() => !alive(pid));
});
test('reload/new session reattaches within shutdown grace', async t => {
  const c = await fixture(t); c.graceMs = 500;
  const a = await acquire(c); a.close();
  const b = await acquire(c); t.after(() => b.close());
  assert.equal((await readFile(join(c.modelsDir, 'starts'), 'utf8')).trim(), 'start');
  b.close();
});
test('external server is reused and never stopped', async t => {
  const c = await fixture(t);
  const p = await startExternal(t, c);
  const lease = await acquire(c); assert.equal(lease.owned, false);
  lease.close(); await sleep(400);
  assert.equal(alive(p.pid), true);
});
test('external router without autoload is not changed or replaced', async t => {
  const c = await fixture(t);
  const p = await startExternal(t, c, ['--no-models-autoload']);
  await assert.rejects(acquire(c), /autoload disabled/);
  assert.equal(alive(p.pid), true);
  assert.equal((await readFile(join(c.modelsDir, 'starts'), 'utf8')).trim(), 'start');
});
test('conflicting managed configuration is rejected without harming first session', async t => {
  const c = await fixture(t);
  const a = await acquire(c); t.after(() => a.close());
  await assert.rejects(acquire({ ...c, context: 16384 }), /different configuration/);
  assert.equal((await discover(c)).models.length, 1);
  a.close();
});
test('unrelated listener is never replaced', async t => {
  const c = await fixture(t);
  const server = http.createServer((_req, res) => res.end('not llama'));
  await new Promise(resolve => server.listen(Number(new URL(c.url).port), '127.0.0.1', resolve));
  t.after(() => server.close());
  await assert.rejects(acquire(c));
  assert.equal(server.listening, true);
  await assert.rejects(readFile(join(c.modelsDir, 'starts')), { code: 'ENOENT' });
});
test('spawn failure produces an actionable error', async t => {
  const c = await fixture(t); c.binary = '/nonexistent/pi-llama-server';
  await assert.rejects(acquire(c), /ENOENT/);
});
test('extension command discovers and selects; generic selection loads and enables thinking', async t => {
  const c = await fixture(t);
  const external = await startExternal(t, c);
  const saved = { ...process.env };
  Object.assign(process.env, { LLAMA_BASE_URL: c.url, PI_LLAMA_RUNTIME_DIR: c.runtimeDir,
    PI_LLAMA_MODELS_DIR: c.modelsDir, PI_LLAMA_PRESET: c.preset, PI_LLAMA_BINARY: fake });
  t.after(() => { for (const key of Object.keys(process.env)) if (!(key in saved)) delete process.env[key]; Object.assign(process.env, saved); });
  const hooks = {}; let command; let provider; let registered = []; const errors = [];
  const ctx = {
    hasUI: true, mode: 'tui', model: undefined,
    waitForIdle: async () => {},
    ui: { setStatus() {}, notify(message, severity) { if (severity === 'error') errors.push(message); }, select: async (_title, ids) => ids[0] },
    modelRegistry: {
      refresh: async () => {
        await provider.refreshModels({ allowNetwork: true, signal: new AbortController().signal, publish: async ({ update }) => { update?.(); return true; } });
        registered = provider.getModels();
        return { aborted: false, errors: new Map() };
      },
      getAvailable: () => registered,
      find: (_provider, id) => registered.find(m => m.id === id),
    },
  };
  const pi = {
    registerProvider(value) { assert.equal(value.id, 'llama.cpp'); provider = value; },
    registerCommand(name, value) { assert.equal(name, 'llama'); command = value; },
    on(name, handler) { hooks[name] = handler; },
    async setModel(model) { ctx.model = model; await hooks.model_select({ model }, ctx); return true; },
  };
  await extension(pi, { stream() {}, streamSimple() {} });
  assert.equal(provider.getModels().length, 1, 'factory discovers before session_start / --list-models');
  assert.ok(await provider.auth.apiKey.check({ credential: { type: 'api_key', env: {} } }));
  assert.equal((await provider.auth.apiKey.resolve({ credential: { type: 'api_key' } })).auth.apiKey, 'local');
  t.after(() => hooks.session_shutdown());
  await command.handler('', ctx);
  assert.deepEqual(errors, []);
  assert.equal(ctx.model.id, 'gemma-test');
  assert.equal(ctx.model.contextWindow, 8192);
  assert.equal(ctx.model.reasoning, true);
  assert.equal((await discover(c)).models[0].status.value, 'loaded');
  await hooks.session_shutdown();
  assert.equal(alive(external.pid), true);
});

test('SIGKILL of the last Pi client releases lease and stops owned router', async t => {
  const c = await fixture(t);
  const module = new URL('../lease.mjs', import.meta.url).href;
  const client = spawn(process.execPath, ['--input-type=module', '-e',
    `import { acquire } from ${JSON.stringify(module)}; const lease = await acquire(JSON.parse(process.argv[1])); console.log('ready'); setInterval(() => {}, 1000);`,
    JSON.stringify(c)], { stdio: ['ignore', 'pipe', 'pipe'] });
  t.after(() => client.kill('SIGKILL'));
  await new Promise((resolve, reject) => {
    const timer = setTimeout(() => reject(new Error('client did not attach')), 5000);
    client.stdout.once('data', () => { clearTimeout(timer); resolve(); });
    client.once('exit', code => { clearTimeout(timer); reject(new Error(`client exited ${code}`)); });
  });
  const pid = Number(await readFile(join(c.modelsDir, 'router.pid'), 'utf8'));
  client.kill('SIGKILL');
  await until(() => !alive(pid));
});
