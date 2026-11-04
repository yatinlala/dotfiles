import type { ExtensionAPI, ProviderModelConfig } from "@earendil-works/pi-coding-agent";

/**
 * Minimal llama.cpp router integration.
 *
 * Discovers models from llama-server's OpenAI-compatible /v1/models endpoint
 * during Pi startup and registers them as a dynamic provider. No third-party
 * package or generated models.json is required.
 *
 * Configuration:
 *   LLAMA_SERVER_URL, or http://127.0.0.1:8080 by default.
 * Multiple URLs may be separated with semicolons.
 */

type RouterModel = {
  id: string;
  aliases?: string[];
  architecture?: { input_modalities?: string[] };
  meta?: { n_ctx?: number; n_ctx_train?: number };
  status?: { args?: string[] };
};

type ModelsResponse = { data?: RouterModel[] };

const DEFAULT_URL = "http://127.0.0.1:8080";
const DEFAULT_CONTEXT = 128_000;
const STARTUP_TIMEOUT_MS = 2_000;

function contextFrom(model: RouterModel): number {
  const reported = model.meta?.n_ctx || model.meta?.n_ctx_train;
  if (reported && reported > 0) return reported;

  const args = model.status?.args ?? [];
  for (const flag of ["--ctx-size", "--fit-ctx"]) {
    const index = args.indexOf(flag);
    const value = Number.parseInt(args[index + 1] ?? "", 10);
    if (index >= 0 && Number.isFinite(value) && value > 0) return value;
  }
  return DEFAULT_CONTEXT;
}

function toPiModel(model: RouterModel): ProviderModelConfig {
  const contextWindow = contextFrom(model);
  const modalities = model.architecture?.input_modalities ?? ["text"];
  const input: ("text" | "image")[] = ["text"];
  if (modalities.includes("image")) input.push("image");

  return {
    id: model.id,
    name: model.aliases?.[0] ?? model.id,
    reasoning: true,
    input,
    contextWindow,
    maxTokens: contextWindow,
    cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
    compat: {
      supportsDeveloperRole: false,
      supportsReasoningEffort: false,
      maxTokensField: "max_tokens",
    },
  };
}

async function discover(url: string): Promise<RouterModel[]> {
  const signal = AbortSignal.timeout(STARTUP_TIMEOUT_MS);
  const response = await fetch(`${url}/v1/models`, { signal });
  if (!response.ok) throw new Error(`HTTP ${response.status}`);
  const payload = (await response.json()) as ModelsResponse;
  if (!Array.isArray(payload.data)) throw new Error("invalid /v1/models response");
  return payload.data.filter((model) => typeof model.id === "string" && model.id.length > 0);
}

function configuredUrls(): string[] {
  // Pi settings are JSON, so importing them would make this extension dependent
  // on Pi's config location. The environment variable is the explicit override;
  // the default matches llama-server. Set LLAMA_SERVER_URL for another address.
  return (process.env.LLAMA_SERVER_URL ?? DEFAULT_URL)
    .split(";")
    .map((url) => url.trim().replace(/\/$/, ""))
    .filter(Boolean);
}

export default async function (pi: ExtensionAPI) {
  for (const url of configuredUrls()) {
    try {
      const models = await discover(url);
      if (models.length === 0) continue;

      // Keep the familiar provider id for the default/single server. Include the
      // URL when several servers are configured to avoid collisions.
      const urls = configuredUrls();
      const providerId = urls.length === 1 ? "llama-cpp" : `llama-cpp=${url}`;
      pi.registerProvider(providerId, {
        name: `Llama.cpp (${url})`,
        baseUrl: `${url}/v1`,
        api: "openai-completions",
        apiKey: "none",
        models: models.map(toPiModel).sort((a, b) => a.id.localeCompare(b.id)),
      });
    } catch {
      // A local server is optional. Stay silent at startup rather than making
      // every Pi invocation noisy when llama-server is not running.
    }
  }
}
