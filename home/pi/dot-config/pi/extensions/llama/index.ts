import type { Model, Provider } from '@earendil-works/pi-ai';
import type { ExtensionAPI, ExtensionContext } from '@earendil-works/pi-coding-agent';
import { readFile, writeFile, rename } from 'node:fs/promises';
import { randomUUID } from 'node:crypto';
import { configuration, discover, endpoint, request, refused, selectable, toPiModel } from './core.mjs';
import { acquire } from './lease.mjs';

const PROVIDER = 'llama.cpp';

export default async function managedLlama(pi: ExtensionAPI, streaming?: Pick<Provider, 'stream' | 'streamSimple'>) {
  const compat = streaming ?? await import('@earendil-works/pi-ai/compat');
  const config = configuration();
  const address = await endpoint(config);
  const catalogPath = address.log.replace(/\.log$/, '.models.json');
  let models: Model<'openai-completions'>[] = [];
  try {
    const cached = JSON.parse(await readFile(catalogPath, 'utf8'));
    if (Array.isArray(cached) && cached.every(m => typeof m.id === 'string' && m.contextWindow > 0 && Array.isArray(m.input))) models = cached.map(m => ({ ...m, api: 'openai-completions', provider: PROVIDER, baseUrl: `${config.url}/v1` }));
  } catch { /* A cache is optional; never cache credentials or provider responses. */ }
  const saveCatalog = async () => {
    const temporary = `${catalogPath}.${randomUUID()}.tmp`;
    await writeFile(temporary, JSON.stringify(models), { mode: 0o600 });
    await rename(temporary, catalogPath);
  };
  const templates = new Map<string, { chat_template?: string }>();
  let lease: Awaited<ReturnType<typeof acquire>> | undefined;
  let attaching: Promise<void> | undefined;
  let disposed = false;
  let selecting = false;

  const attach = async (ctx: ExtensionContext) => {
    if (disposed) throw new Error('This Pi session is closing');
    if (lease && !lease.closed) return;
    attaching ??= (async () => {
      const acquired = await acquire(config, message => {
        lease = undefined;
        ctx.ui.setStatus('llama-managed', undefined);
        if (!disposed) ctx.ui.notify(message, 'warning');
      });
      if (disposed) { acquired.close(); throw new Error('This Pi session is closing'); }
      lease = acquired;
      ctx.ui.setStatus('llama-managed', acquired.owned ? 'llama: shared, Pi-managed' : 'llama: external');
    })();
    try { await attaching; } finally { attaching = undefined; }
  };

  const catalogModels = async (signal?: AbortSignal) => {
    const catalog = await discover(config, signal);
    const selected = catalog.models.filter(m => selectable(m, catalog.autoload));
    // Never query props for unloaded/sleeping models: that can wake/load them.
    const result: Model<'openai-completions'>[] = [];
    for (const model of selected) {
      const outputs = model.architecture?.output_modalities;
      if (outputs?.includes('decisions') && !outputs.includes('text')) continue;
      if (model.status.value === 'loaded') {
        templates.set(model.id, await request(config, `/props?${new URLSearchParams({ model: model.id, autoload: 'false' })}`, { signal }));
      }
      result.push({ ...toPiModel(model, templates.get(model.id), config.context), api: 'openai-completions', provider: PROVIDER, baseUrl: `${config.url}/v1` });
    }
    return result.sort((a, b) => a.id.localeCompare(b.id));
  };

  // Initial discovery makes --list-models and startup model selection work without
  // a session_start event. No supervisor/socket/background work starts here.
  try { models = await catalogModels(); await saveCatalog(); }
  catch { /* Keep the last known catalog so a saved local model can reconnect. */ }

  const provider: Provider = {
    id: PROVIDER,
    name: 'llama.cpp', baseUrl: `${config.url}/v1`,
    // Native auth intentionally handles saved keyless /login credentials, which
    // legacy API-key provider composition treats as unavailable.
    auth: {
      apiKey: {
        name: 'Managed llama.cpp router',
        check: async () => ({ type: 'api_key', source: 'managed llama.cpp configuration' }),
        resolve: async () => ({ auth: { apiKey: config.apiKey || 'local', baseUrl: `${config.url}/v1` }, source: 'managed llama.cpp configuration' }),
      },
    },
    getModels: () => models,
    async refreshModels(context) {
      if (!context.allowNetwork || context.signal.aborted) return;
      try {
        const updated = await catalogModels(context.signal);
        if (await context.publish({ update: () => { models = updated; } })) await saveCatalog();
      } catch (error) {
        if (!refused(error)) throw error; // retain cache for offline model selection/startup
      }
    },
    stream: (model, context, options) => compat.stream(model, context, options),
    streamSimple: (model, context, options) => compat.streamSimple(model, context, options),
  };
  pi.registerProvider(provider);

  const refresh = async (ctx: ExtensionContext) => {
    const result = await ctx.modelRegistry.refresh({
      providers: [PROVIDER], allowNetwork: true, signal: AbortSignal.timeout(15000),
    });
    if (result.aborted) throw new Error('llama.cpp model discovery timed out');
    const error = result.errors.get(PROVIDER);
    if (error) throw error;
  };

  const prepareModel = async (ctx: ExtensionContext, id: string) => {
    await attach(ctx);
    let catalog = await discover(config);
    const target = catalog.models.find(m => m.id === id);
    if (!target) throw new Error(`Router no longer has model ${id}; run /llama to refresh`);
    if (!['loaded', 'sleeping'].includes(target.status.value)) {
      ctx.ui.setStatus('llama-loading', `Loading ${id}…`);
      try {
        if (target.status.value === 'unloaded') {
          try {
            await request(config, '/models/load', { method: 'POST', body: JSON.stringify({ model: id }), signal: ctx.signal, timeout: 15000 });
          } catch (error) {
            // Another attached Pi may already have initiated this exact load.
            const current = (await discover(config, ctx.signal)).models.find(m => m.id === id);
            if (!current || !['loading', 'loaded', 'sleeping'].includes(current.status.value)) throw error;
          }
        }
        const deadline = Date.now() + 180000;
        while (true) {
          if (disposed) throw new Error('Pi session closed while loading');
          if (ctx.signal?.aborted) throw new Error('Model loading interrupted');
          catalog = await discover(config, ctx.signal);
          const current = catalog.models.find(m => m.id === id);
          if (current?.status.value === 'loaded' || current?.status.value === 'sleeping') break;
          if (!current || current.status.failed || current.status.value === 'unloaded') {
            throw new Error(`Failed to load ${id}; see ${lease?.owned ? lease.log : 'the external router log'}`);
          }
          if (Date.now() > deadline) throw new Error(`Loading ${id} timed out; the shared server was left running`);
          await new Promise(resolve => setTimeout(resolve, 250));
        }
      } finally { ctx.ui.setStatus('llama-loading', undefined); }
    }
    await refresh(ctx);
    // Loading exposes the chat template, so update thinking capability immediately.
    const updated = ctx.modelRegistry.find(PROVIDER, id);
    if (updated && ctx.model?.provider === PROVIDER && ctx.model.id === id &&
        (ctx.model.reasoning !== updated.reasoning || ctx.model.contextWindow !== updated.contextWindow)) {
      await pi.setModel(updated);
    }
  };

  pi.registerCommand('llama', {
    description: 'Start/reuse the llama.cpp router and select a local model',
    handler: async (_args, ctx) => {
      await ctx.waitForIdle();
      try {
        ctx.ui.setStatus('llama-loading', 'Connecting to llama.cpp…');
        await attach(ctx);
        await refresh(ctx);
        ctx.ui.setStatus('llama-loading', undefined);
        const available = ctx.modelRegistry.getAvailable().filter(m => m.provider === PROVIDER);
        if (!available.length) { ctx.ui.notify(`No chat models discovered at ${config.url}`, 'warning'); return; }
        if (!ctx.hasUI) return;
        const id = await ctx.ui.select(`llama.cpp · ${config.url}`, available.map(m => m.id));
        const selected = available.find(m => m.id === id);
        if (selected && !(await pi.setModel(selected))) throw new Error('Could not select llama.cpp model');
      } catch (error) {
        ctx.ui.notify(error instanceof Error ? error.message : String(error), 'error');
      } finally { ctx.ui.setStatus('llama-loading', undefined); }
    },
  });

  pi.on('model_select', async (event, ctx) => {
    if (event.model.provider !== PROVIDER || selecting) return;
    selecting = true;
    try { await prepareModel(ctx, event.model.id); }
    catch (error) { ctx.ui.notify(error instanceof Error ? error.message : String(error), 'error'); }
    finally { selecting = false; }
  });

  pi.on('before_agent_start', async (_event, ctx) => {
    // Also covers restored sessions and a server that exited since selection.
    if (ctx.model?.provider === PROVIDER) await prepareModel(ctx, ctx.model.id);
  });

  pi.on('session_start', async (_event, ctx) => {
    try {
      if (ctx.model?.provider === PROVIDER) await prepareModel(ctx, ctx.model.id);
      else {
        // Discover an already running router, but don't start one merely by launching Pi.
        await discover(config);
        await attach(ctx);
        await refresh(ctx);
      }
    } catch (error) {
      if (ctx.model?.provider === PROVIDER) ctx.ui.notify(error instanceof Error ? error.message : String(error), 'warning');
    }
  });

  pi.on('session_shutdown', async () => {
    disposed = true;
    try { await attaching; } catch { /* attach closes a late lease itself */ }
    lease?.close(); lease = undefined;
  });
}
