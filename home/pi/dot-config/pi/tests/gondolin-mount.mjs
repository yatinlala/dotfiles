// Host-only integration check: start an isolated VM with the read-only Pi mount.
// Run: node tests/gondolin-mount.mjs /path/to/pi-coding-agent
import assert from 'node:assert/strict';
import fs from 'node:fs';
import { stripTypeScriptTypes } from 'node:module';
const { VM, ReadonlyProvider, RealFSProvider } = await import('../extensions/gondolin/node_modules/@earendil-works/gondolin/dist/src/index.js');
const pkg = fs.realpathSync(process.argv[2]);
stripTypeScriptTypes(fs.readFileSync(new URL('../extensions/gondolin/index.ts', import.meta.url), 'utf8'));
const vm = await VM.create({ sessionLabel: 'pi-readonly-mount-test', vfs: { mounts: {
  '/opt/pi': new ReadonlyProvider(new RealFSProvider(pkg)),
} } });
try {
  // Also exercise the Vim regression suite inside the VM using the mounted dependencies.
  await vm.fs.mkdir('/tmp/pi-check/tests', { recursive: true });
  await vm.fs.mkdir('/tmp/pi-check/extensions', { recursive: true });
  for (const file of ['tests/vim-editor.mjs', 'extensions/vim-editor.ts', 'keybindings.json']) {
    await vm.fs.writeFile(`/tmp/pi-check/${file}`, fs.readFileSync(new URL(`../${file}`, import.meta.url)));
  }
  const result = await vm.exec(['/bin/sh', '-lc', `
    set -eu
    test -r /opt/pi/docs/extensions.md
    test -r /opt/pi/examples/extensions/modal-editor.ts
    test -r /opt/pi/dist/index.js
    test -r /opt/pi/node_modules/@earendil-works/pi-tui/dist/index.js
    if touch /opt/pi/.gondolin-readonly-test 2>/dev/null; then
      echo 'ERROR: mount is writable'; exit 1
    fi
    node --input-type=module -e 'const m = await import("/opt/pi/node_modules/@earendil-works/pi-tui/dist/index.js"); if (!m.TuiAltScreen) process.exit(1)'
    echo 'PASS: Pi docs, examples, runtime and dependencies readable; writes denied; TUI import works in VM'
    node /tmp/pi-check/tests/vim-editor.mjs /opt/pi
  `]);
  assert.equal(result.exitCode, 0, result.stderr + result.stdout);
  console.log(result.stdout.trim());
} finally { await vm.close(); }
