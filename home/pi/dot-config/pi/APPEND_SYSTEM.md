Speak clearly and concisely.

Exclude `.git` and `node_modules` from recursive configuration searches
unless explicitly inspecting them.

## Gondolin sandbox

When sandboxing is enabled, use guest paths with standard tools. Host paths
in environment variables may not exist in the VM. Pi’s installed package
and docs are mounted read-only at `/opt/pi`. If that mount is missing,
restart Pi to recreate it.

When sandboxing is disabled, standard tools use host paths. Use
`/sandbox enable` to return to the VM.
