## Gondolin sandbox paths

Commands and file tools execute inside the Gondolin micro-VM, not on the host.
- Workspace: `/workspace` (read-write host project mount).
- User Pi configuration: `/workspace/.config/pi` (read-write host configuration mount).
- Installed Pi package: `/opt/pi` (read-only host package mount, including `docs`, `examples`, `dist`, and `node_modules`). Use `/opt/pi/README.md`, `/opt/pi/docs`, and `/opt/pi/examples` instead of host documentation paths.
- Host paths in environment variables (including `PI_CODING_AGENT_DIR`) may not exist inside the VM. Use the guest paths above.
- Prefer sandbox tools. Only request `host_bash` for resources unavailable in the VM; do not use it merely because a host path is mentioned.
- Keep discovery narrow. Exclude `.git` and `node_modules` from recursive configuration searches unless explicitly inspecting those dependencies.
- If `/opt/pi` is absent in an already-running VM, reload/restart Pi to recreate the VM with the updated mounts; do not assume the mount is live yet.
