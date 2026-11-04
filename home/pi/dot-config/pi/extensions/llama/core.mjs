import { createHash, randomBytes } from 'node:crypto';
import { mkdir, open, readFile, lstat } from 'node:fs/promises';
import { homedir } from 'node:os';
import { join, resolve } from 'node:path';
import { setTimeout as sleep } from 'node:timers/promises';

export function configuration(env = process.env) {
  const url = new URL(env.LLAMA_BASE_URL || env.LLAMA_SERVER_URL || 'http://127.0.0.1:8081');
  if (!['http:', 'https:'].includes(url.protocol) || url.username || url.password || url.search || url.hash) {
    throw new Error('LLAMA_BASE_URL must be an http(s) URL without credentials, query, or fragment');
  }
  url.pathname = url.pathname.replace(/\/+$/, '').replace(/\/v1$/, '');
  if (url.hostname === 'localhost') url.hostname = '127.0.0.1';
  const root = env.LLMS || join(homedir(), '.local/share/llms');
  return {
    url: url.toString().replace(/\/$/, ''),
    apiKey: env.LLAMA_API_KEY || '',
    binary: env.PI_LLAMA_BINARY || 'llama-server',
    modelsDir: resolve(env.PI_LLAMA_MODELS_DIR || join(root, 'router')),
    preset: resolve(env.PI_LLAMA_PRESET || join(env.XDG_CONFIG_HOME || join(homedir(), '.config'), 'llama/config.ini')),
    context: 8192,
    startupMs: 15000,
    graceMs: 1500,
    runtimeDir: resolve(env.PI_LLAMA_RUNTIME_DIR || join(env.XDG_RUNTIME_DIR || join(homedir(), '.cache'), 'pi-llama-managed')),
  };
}

export const fingerprint = config => createHash('sha256').update(JSON.stringify([
  config.url, config.binary, config.modelsDir, config.preset, config.context, config.apiKey,
])).digest('hex');

export async function endpoint(config) {
  if (process.platform !== 'linux') throw new Error('Managed llama supervisor currently requires Linux');
  await mkdir(config.runtimeDir, { recursive: true, mode: 0o700 });
  const stat = await lstat(config.runtimeDir);
  if (!stat.isDirectory() || stat.uid !== process.getuid() || (stat.mode & 0o077)) {
    throw new Error(`Runtime directory must be owned by you and mode 0700: ${config.runtimeDir}`);
  }
  const tokenFile = join(config.runtimeDir, 'token');
  try {
    const file = await open(tokenFile, 'wx', 0o600);
    try { await file.writeFile(randomBytes(32).toString('hex')); } finally { await file.close(); }
  } catch (error) { if (error.code !== 'EEXIST') throw error; }
  // Another session may have created the file but not finished writing it yet.
  let token;
  for (let i = 0; i < 20; i++) {
    token = await readFile(tokenFile, 'utf8');
    if (/^[a-f0-9]{64}$/.test(token)) break;
    await sleep(10);
  }
  if (!/^[a-f0-9]{64}$/.test(token)) throw new Error(`Invalid supervisor token: ${tokenFile}`);
  const id = createHash('sha256').update(`${token}\n${config.url}`).digest('hex').slice(0, 32);
  // Linux abstract sockets are removed by the kernel, including after crashes.
  // The private random token makes the address unguessable to other users.
  return { path: `\0pi-llama-${process.getuid()}-${id}`, token, log: join(config.runtimeDir, `${id}.log`) };
}

export async function request(config, path, { signal, timeout = 3000, ...init } = {}) {
  const headers = new Headers(init.headers);
  if (config.apiKey) headers.set('Authorization', `Bearer ${config.apiKey}`);
  if (init.body) headers.set('Content-Type', 'application/json');
  const response = await fetch(`${config.url}${path}`, {
    ...init, headers, signal: signal ? AbortSignal.any([signal, AbortSignal.timeout(timeout)]) : AbortSignal.timeout(timeout),
  });
  if (!response.ok) throw new Error(`llama.cpp ${path}: HTTP ${response.status}`);
  return response.json();
}

export function refused(error) {
  return error?.code === 'ECONNREFUSED' || error?.cause?.code === 'ECONNREFUSED' ||
    error?.cause?.errors?.some(refused) === true;
}

export async function discover(config, signal) {
  const catalog = await request(config, '/models', { signal });
  if (!Array.isArray(catalog?.data) || !catalog.data.every(m => typeof m.id === 'string' && typeof m.status?.value === 'string')) {
    throw new Error(`${config.url} is not a llama.cpp router (expected /models with model statuses)`);
  }
  const props = await request(config, '/props', { signal });
  if (typeof props.models_autoload !== 'boolean') throw new Error(`${config.url} is not a supported llama.cpp router`);
  return { models: catalog.data, autoload: props.models_autoload };
}

export function selectable(model, autoload) {
  return ['loaded', 'sleeping'].includes(model.status.value) ||
    (autoload && model.status.value === 'unloaded' && !model.status.failed && ['preset', 'models_dir'].includes(model.source));
}

export function contextFrom(model, fallback = 8192) {
  if (model.meta?.n_ctx > 0) return model.meta.n_ctx;
  const args = model.status.args || [];
  for (let i = 0; i < args.length - 1; i++) {
    if (['--ctx-size', '-c', '-ctx'].includes(args[i]) && Number(args[i + 1]) > 0) return Number(args[i + 1]);
  }
  return fallback; // training context_length is not the server's configured context
}

export function toPiModel(model, props, fallback) {
  const contextWindow = contextFrom(model, fallback);
  const reasoning = typeof props?.chat_template === 'string' && props.chat_template.includes('enable_thinking');
  return {
    id: model.id, name: model.id, reasoning,
    ...(reasoning ? { thinkingLevelMap: { off: 'off', minimal: null, low: null, medium: 'medium', high: null, xhigh: null } } : {}),
    input: model.architecture?.input_modalities?.includes('image') ? ['text', 'image'] : ['text'],
    contextWindow, maxTokens: contextWindow,
    cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
    compat: {
      supportsStore: false, supportsDeveloperRole: false, supportsReasoningEffort: false,
      supportsUsageInStreaming: true, supportsStrictMode: false, maxTokensField: 'max_tokens',
      ...(reasoning ? { thinkingFormat: 'qwen-chat-template' } : {}),
    },
  };
}
