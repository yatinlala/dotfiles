## Gondolin sandbox paths

The following guest-path rules apply only while sandboxing is enabled (the default). When the user runs `/sandbox disable`, standard tools execute directly on the host without per-command approval; use host paths instead. `/sandbox enable` restores VM routing. The extension reports the current mode before each agent turn.

When enabled, commands and file tools execute inside the Gondolin micro-VM, not on the host.
- Workspace: `/workspace` (read-write host project mount).
- User Pi configuration: `/pi-config` (read-only host configuration mount). Config changes require a narrow `host_bash` invocation and explicit approval through Pi's confirmation UI; never unlock the mount.
- Installed Pi package: `/opt/pi` (read-only host package mount, including `docs`, `examples`, `dist`, and `node_modules`). Use `/opt/pi/README.md`, `/opt/pi/docs`, and `/opt/pi/examples` instead of host documentation paths.
- Host paths in environment variables (including `PI_CODING_AGENT_DIR`) may not exist inside the VM. Use the guest paths above.
- Prefer sandbox tools. Only request `host_bash` for resources unavailable in the VM; do not use it merely because a host path is mentioned.
- Keep discovery narrow. Exclude `.git` and `node_modules` from recursive configuration searches unless explicitly inspecting those dependencies.
- If `/opt/pi` is absent in an already-running VM, reload/restart Pi to recreate the VM with the updated mounts; do not assume the mount is live yet.
