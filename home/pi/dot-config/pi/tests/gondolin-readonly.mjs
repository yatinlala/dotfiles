// Provider-level regression check; no host execution or VM needed.
// Run: node /pi-config/tests/gondolin-readonly.mjs
import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import { ReadonlyProvider, RealFSProvider } from '../extensions/gondolin/node_modules/@earendil-works/gondolin/dist/src/index.js';
const root = await fs.mkdtemp(path.join(os.tmpdir(), 'gondolin-readonly-'));
try {
  await fs.writeFile(path.join(root, 'config'), 'original');
  const provider = new ReadonlyProvider(new RealFSProvider(root));
  assert.equal(provider.readonly, true);
  await provider.stat('/config');
  for (const flags of ['w', 'a', 'r+', 'w+', 'a+', 'wx']) {
    await assert.rejects(provider.open('/config', flags), { errno: 30 });
  }
  for (const operation of [
    () => provider.mkdir('/new'),
    () => provider.unlink('/config'),
    () => provider.rename('/config', '/other'),
    () => provider.rmdir('/'),
    () => provider.symlink('/config', '/alias'),
    () => provider.link('/config', '/alias'),
  ]) await assert.rejects(operation(), { errno: 30 });
  assert.equal(await fs.readFile(path.join(root, 'config'), 'utf8'), 'original');
  const source = await fs.readFile(new URL('../extensions/gondolin/index.ts', import.meta.url), 'utf8');
  assert.ok(source.includes('[GUEST_CONFIG]: new ReadonlyProvider(new RealFSProvider(configSource))'));
  const hostTool = await fs.readFile(new URL('../extensions/host-bash.ts', import.meta.url), 'utf8');
  assert.ok(hostTool.indexOf('await ctx.ui.confirm(') < hostTool.indexOf('return hostBash.execute('));
  assert.ok(hostTool.includes('if (!ctx.hasUI)'));
  assert.ok(hostTool.includes('if (!approved) throw'));
  console.log('PASS: config mount is read-only; provider rejects mutations; host tool retains approval checks');
} finally {
  await fs.rm(root, { recursive: true, force: true });
}
