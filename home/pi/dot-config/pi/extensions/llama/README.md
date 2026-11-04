# Managed llama.cpp for Pi

Personal extension for Pi 1.5+ on Linux with a current Node.js (22+).
No third-party runtime dependencies. Pi remains unmodified.

## Usage

`/llama` starts or reuses the router, discovers its models, and offers a local
model selector. They also appear under **llama.cpp** in the normal `/model`
picker. Selecting a model loads it, without a separate management step.
Restoring a session using llama.cpp also reconnects/starts the router.
Launching Pi with another provider does not start a router. A private cache of
model metadata lets saved local-model sessions reconnect even when the router
is stopped. Cached models can also be selected directly through `/model`.

Defaults match this machine:

- Server: `http://127.0.0.1:8081`
- Executable: `llama-server` on PATH
- Discovery directory: `$LLMS/router`, falling back to
  `~/.local/share/llms/router`
- Optional preset: `${XDG_CONFIG_HOME:-~/.config}/llama/config.ini`
- Context: 8192; GPU layers: all; Jinja and router autoload enabled

The preset still supplies per-model MTP options. Model/projector/draft paths
come from the discovered symlink layout. The extension never moves model files.

Configuration environment overrides:

| Variable | Purpose |
| --- | --- |
| `LLAMA_BASE_URL` | Server URL (preferred); legacy `LLAMA_SERVER_URL` also accepted |
| `LLAMA_API_KEY` | Optional key for HTTP requests and any spawned server |
| `PI_LLAMA_BINARY` | Server executable/path |
| `PI_LLAMA_MODELS_DIR` | Exact discovery directory |
| `PI_LLAMA_PRESET` | Preset file; missing file is allowed |
| `PI_LLAMA_RUNTIME_DIR` | Private mode-0700 directory for token and logs |

These are process environment settings, not shell function definitions. Pi does
not source shell startup files. No `/login` is needed for this local extension;
previous saved credentials are not deleted. Only one endpoint per Pi process
is supported. Different endpoints have separate supervisors.

## Ownership and multi-session lifecycle

A small detached Node supervisor is keyed by endpoint. Each Pi runtime attaches
with a Unix-socket lease. The kernel serializes supervisor startup by binding a
unique abstract socket. A secret in a private runtime directory prevents other
users from guessing/authenticating that socket; Linux removes it automatically
on supervisor exit, so there is no stale PID/lock-file recovery race.

- Router already running: validate and reuse it; never stop/reconfigure it.
- Router absent: spawn one, wait for readiness, and own that process group.
- Two Pi sessions: share one supervisor/router and hold separate connections.
- Last connection closes: wait 1.5 seconds (for `/reload`/session replacement),
  then terminate the owned router process group; force-kill after five seconds.
- Pi crashes or receives SIGKILL: the OS closes its socket, releasing its lease.
- An unresponsive/wrong/authenticated service on the endpoint is an error, not
  permission to launch another server. An external router with autoload disabled
  must be restarted by its owner.
- Different launch settings for the same endpoint are rejected rather than
  silently changing the shared server.
- Automatic spawning is restricted to local loopback HTTP URLs. Remote routers
  can be reused, but must be started externally.

Clients attached through this extension count as leases. Unrelated programs
using the managed router do **not** keep it alive. Use an external router if
non-Pi clients need an independent lifetime. If the supervisor itself is forcibly
killed with SIGKILL (rather than Pi), graceful child cleanup cannot run.

Logs are in `$XDG_RUNTIME_DIR/pi-llama-managed/`, or
`~/.cache/pi-llama-managed/`. The endpoint-specific log path is included in
startup/load errors. Logs are mode 0600 and appended; delete old logs when idle
if needed. Prompts/responses are not intentionally logged by this extension,
but llama-server controls its own output.

## Compatibility fix

Pi's built-in provider currently permits unloaded `source: "preset"` models but
not `source: "models_dir"` models. Both are selectable with router autoload.
This extension handles both and respects the configured runtime context rather
than the GGUF's larger training context. Thinking controls are refreshed after
loading exposes a model's chat template. Generation/streaming/tool calls use
Pi's existing OpenAI Chat Completions implementation.

This replaces the personal `llama-cpp-router.ts` extension and disables
`builtin:llama.cpp` to avoid duplicate `/llama` commands/providers. It intentionally
replaces the built-in management/download/classifier UI; download with llama.cpp
or temporarily re-enable the built-in extension if you need those features.

## Tests

```bash
cd ~/.config/pi/extensions/llama
npm test
```

Tests use a fake HTTP router and actual supervisors/processes, not a GPU/model.
They cover simultaneous startup, last-client cleanup, Pi SIGKILL, external-server
ownership, autoload, config conflicts, invalid endpoints, spawn errors, model
selection/loading, context limits, and thinking capability refresh.
