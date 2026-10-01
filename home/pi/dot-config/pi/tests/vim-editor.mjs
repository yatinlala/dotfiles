// Run: node ~/.config/pi/tests/vim-editor.mjs /path/to/pi-coding-agent
// In Gondolin after reload: node /workspace/.config/pi/tests/vim-editor.mjs /opt/pi
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { pathToFileURL } from 'node:url';
import { stripTypeScriptTypes } from 'node:module';

const pkg = process.argv[2] ?? '/opt/pi';
const load = (file) => import(pathToFileURL(path.join(pkg, file)).href);
const { CustomEditor } = await load('dist/modes/interactive/components/custom-editor.js');
const { KeybindingsManager } = await load('dist/core/keybindings.js');
const { createChatViewport } = await load('dist/modes/interactive/chat-viewport.js');
const tuiLib = await load('node_modules/@earendil-works/pi-tui/dist/index.js');
const { TuiAltScreen, TuiMainScreen, matchesKey, truncateToWidth, visibleWidth, setKeybindings, setKittyProtocolActive } = tuiLib;
const bindings = new KeybindingsManager(JSON.parse(fs.readFileSync(new URL('../keybindings.json', import.meta.url), 'utf8')));
setKeybindings(bindings);
const source = fs.readFileSync(new URL('../extensions/vim-editor.ts', import.meta.url), 'utf8')
  .replace(/^import .*;\n/gm, '').replace('export default function', 'function extension');
const VimEditor = new Function('CustomEditor', 'matchesKey', 'truncateToWidth', 'visibleWidth',
  stripTypeScriptTypes(source) + '; return VimEditor;')(CustomEditor, matchesKey, truncateToWidth, visibleWidth);
const theme = { borderColor: s => s, selectList: {} };

function setup(fullscreen = true) {
  let input;
  const terminal = new Proxy({ rows: 30, columns: 100, kittyProtocolActive: false,
    start(onInput) { input = onInput; } }, { get: (obj, key) => obj[key] ?? (() => {}) });
  const tui = fullscreen ? new TuiAltScreen(terminal) : new TuiMainScreen(terminal);
  const editor = new VimEditor(tui, theme, bindings);
  const empty = { render: () => [], invalidate() {} };
  const document = { render: () => Array.from({ length: 200 }, (_, i) => `Message ${i}`), invalidate() {} };
  if (fullscreen) {
    const chat = createChatViewport({ document, editor, pendingMessages: empty, status: empty, footer: empty });
    tui.setLayoutRoot(chat.root);
  } else { tui.addChild(document); tui.addChild(editor); }
  tui.setFocus(editor);
  tui.start();
  tui.renderNow();
  return { tui, editor, key(data) { input(data); tui.renderNow(); } };
}

for (const kitty of [false, true]) {
  setKittyProtocolActive(kitty);
  const { tui, editor, key } = setup();
  try {
    key('draft words');
    key('\x1b[127;5u');
    assert.equal(editor.getText(), 'draft ', 'insert Ctrl-Backspace deletes one word');
    key('\x1b');
    const bottom = tui.viewportTop;
    const draft = editor.getText();
    const cursor = editor.getCursor();
    key('K'); assert.equal(tui.viewportTop, bottom - 1);
    key('J'); assert.equal(tui.viewportTop, bottom);
    key('\x15'); assert.equal(tui.viewportTop, bottom - 15);
    key('\x04'); assert.equal(tui.viewportTop, bottom);
    key('g'); assert.equal(tui.viewportTop, bottom);
    key('g'); assert.equal(tui.viewportTop, 0);
    key('5'); key('J'); assert.equal(tui.viewportTop, 5);
    key('G'); assert.equal(tui.viewportTop, bottom); assert.equal(tui.isFollowingOutput, true);
    assert.equal(editor.getText(), draft); assert.deepEqual(editor.getCursor(), cursor);
    key('g'); key('\x1b'); key('g'); assert.equal(tui.viewportTop, bottom); key('g'); assert.equal(tui.viewportTop, 0);
    key('G');
    key('\x1b[107;2:3u'); assert.equal(tui.viewportTop, bottom, 'key release does not scroll');
    key('d'); key('b'); assert.equal(editor.getText(), '', 'delete operator still works');
    key('u'); assert.equal(editor.getText(), draft, 'undo still works');
    const received = [];
    const overlay = tui.showOverlay({ render: () => ['Dialog'], invalidate() {}, handleInput: d => received.push(d) });
    for (const d of ['K', 'J', '\x15', '\x04', 'g', 'g', 'G']) key(d);
    assert.equal(received.length, 7); assert.equal(tui.viewportTop, bottom);
    overlay.hide();
    key('i'); key('jkggG'); assert.equal(editor.getText(), 'draft jkggG', 'insert letters remain text');
    editor.setText('one\ntwo');
    key('\x1b');
    const beforeNavigation = tui.viewportTop;
    key('k'); assert.equal(editor.getCursor().line, 0);
    key('j'); assert.equal(editor.getCursor().line, 1);
    assert.equal(tui.viewportTop, beforeNavigation, 'lowercase j/k navigate draft without scrolling chat');
    key('i'); key('JK'); assert.equal(editor.getText(), 'one\ntwoJK');
    console.log(`PASS real fullscreen input routing (Kitty ${kitty ? 'on' : 'off'}): scrolling, counts, draft preservation, Ctrl-Backspace, undo, operators, Escape, releases, overlays`);
  } finally { tui.stop(); }
}
setKittyProtocolActive(false);
const { tui, editor, key } = setup(false);
try {
  editor.setText('one\ntwo'); key('\x1b'); key('k'); assert.equal(editor.getCursor().line, 0);
  key('j'); assert.equal(editor.getCursor().line, 1);
  console.log('PASS regular-screen j/k draft navigation');
} finally { tui.stop(); }
