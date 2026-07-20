import { CustomEditor, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { matchesKey, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

type Mode = "normal" | "insert";
type Operator = "delete" | "change" | undefined;
type Find = { character: string; direction: 1 | -1; till: boolean };

/** A pragmatic Vim layer over Pi's normal editor. */
class VimEditor extends CustomEditor {
  private mode: Mode = "insert";
  private operator: Operator;
  private count = "";
  private pendingFind?: Omit<Find, "character">;
  private lastFind?: Find;

  private redraw(): void {
    this.tui.requestRender();
  }

  private insert(): void {
    this.mode = "insert";
    this.operator = undefined;
    this.count = "";
    this.redraw();
  }

  private normal(): void {
    this.mode = "normal";
    this.operator = undefined;
    this.count = "";
    this.redraw();
  }

  private repeat(action: () => void): void {
    const count = Math.max(1, Number(this.count) || 1);
    this.count = "";
    for (let i = 0; i < count; i++) action();
  }

  private send(data: string): void {
    super.handleInput(data);
  }

  /** Move to a Vim f/F/t/T target. Searches only the current logical line. */
  private find(find: Find): void {
    const { line, col } = this.getCursor();
    const text = this.getLines()[line] ?? "";
    const hit = find.direction === 1
      ? text.indexOf(find.character, col + 1)
      : text.lastIndexOf(find.character, col - 1);
    if (hit < 0) return;

    // Editor keeps its state private, but exposes cursor reads. Setting this
    // small runtime state is the only way to position a custom editor exactly
    // on a same-line character without rewriting its text.
    const state = (this as unknown as {
      state: { cursorLine: number; cursorCol: number };
    }).state;
    state.cursorLine = line;
    // t stops just before its target; Vim's reverse T stops just after it.
    state.cursorCol = find.till ? hit - find.direction : hit;
    this.redraw();
  }

  private beginFind(direction: 1 | -1, till: boolean): void {
    this.pendingFind = { direction, till };
    this.count = "";
    this.redraw();
  }

  private deleteMotion(key: string): boolean {
    const finish = (sequence: string) => {
      this.repeat(() => this.send(sequence));
      const change = this.operator === "change";
      this.operator = undefined;
      if (change) this.insert();
      else this.redraw();
    };

    switch (key) {
      case "d": // dd
        // Delete the current line's contents and its following newline.
        this.repeat(() => {
          this.send("\x01"); // Ctrl-A
          this.send("\x0b"); // Ctrl-K
          this.send("\x1b[3~"); // Delete (joins next line when present)
        });
        {
          const change = this.operator === "change";
          this.operator = undefined;
          if (change) this.insert(); else this.redraw();
        }
        return true;
      // Use Kitty's unambiguous Alt-D sequence rather than ESC+d.  Pi enables
      // the Kitty keyboard protocol in terminals that support it, where the
      // legacy ESC+d sequence is deliberately not recognized as Alt-D.
      case "w": case "e": finish("\x1b[100;3u"); return true; // Alt-D, delete word forward
      case "b": finish("\x17"); return true; // Ctrl-W, delete word backward
      case "$": finish("\x0b"); return true; // Ctrl-K
      case "0": finish("\x15"); return true; // Ctrl-U
      case "h": finish("\x7f"); return true;
      case "l": finish("\x1b[3~"); return true;
      default: return false;
    }
  }

  handleInput(data: string): void {
    if (matchesKey(data, "escape")) {
      // Unlike the stock editor, Esc is strictly the modal switch requested here.
      this.normal();
      return;
    }

    if (this.mode === "insert") {
      super.handleInput(data);
      return;
    }

    if (this.pendingFind) {
      const pending = this.pendingFind;
      this.pendingFind = undefined;
      this.lastFind = { ...pending, character: data };
      this.find(this.lastFind);
      return;
    }

    // Preserve Pi/application shortcuts (Ctrl-C, Ctrl-D, paste, etc.).
    if (data.length !== 1 || data.charCodeAt(0) < 32) {
      super.handleInput(data);
      return;
    }

    if (this.operator) {
      if (this.deleteMotion(data)) return;
      // Invalid operator/motion: cancel it, as Vim does.
      this.operator = undefined;
      this.redraw();
      return;
    }

    if (/^[1-9]$/.test(data) || (data === "0" && this.count)) {
      this.count += data;
      this.redraw();
      return;
    }

    switch (data) {
      case "i": this.insert(); return;
      case "a": this.send("\x1b[C"); this.insert(); return;
      case "I": this.send("\x01"); this.insert(); return;
      case "A": this.send("\x05"); this.insert(); return;
      case "h": this.repeat(() => this.send("\x1b[D")); return;
      case "j": this.repeat(() => this.send("\x1b[B")); return;
      case "k": this.repeat(() => this.send("\x1b[A")); return;
      case "l": this.repeat(() => this.send("\x1b[C")); return;
      case "w": this.repeat(() => this.send("\x1b[1;5C")); return; // Ctrl-Right
      case "b": this.repeat(() => this.send("\x1b[1;5D")); return; // Ctrl-Left
      case "0": this.send("\x01"); return;
      case "^": this.send("\x01"); return;
      case "$": this.send("\x05"); return;
      case "x": this.repeat(() => this.send("\x1b[3~")); return;
      case "X": this.repeat(() => this.send("\x7f")); return;
      case "d": this.operator = "delete"; this.redraw(); return;
      case "c": this.operator = "change"; this.redraw(); return;
      case "f": this.beginFind(1, false); return;
      case "F": this.beginFind(-1, false); return;
      case "t": this.beginFind(1, true); return;
      case "T": this.beginFind(-1, true); return;
      case ";": if (this.lastFind) this.find(this.lastFind); return;
      case ",":
        if (this.lastFind) this.find({ ...this.lastFind, direction: this.lastFind.direction === 1 ? -1 : 1 });
        return;
      case "o": this.send("\x05"); this.send("\x0a"); this.insert(); return;
      case "O": this.send("\x01"); this.send("\x0a"); this.send("\x1b[A"); this.insert(); return;
      case "u": this.send("\x1f"); return; // Ctrl-_, Pi's undo binding
      default: this.count = ""; this.redraw(); return;
    }
  }

  render(width: number): string[] {
    const lines = super.render(width);
    if (lines.length === 0) return lines;
    const pending = this.operator === "delete" ? " d" : this.operator === "change" ? " c" : "";
    const label = ` ${this.mode.toUpperCase()}${pending} `;
    const last = lines.length - 1;
    if (visibleWidth(lines[last]!) >= label.length) {
      lines[last] = truncateToWidth(lines[last]!, width - label.length, "") + label;
    }
    return lines;
  }
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    ctx.ui.setEditorComponent((tui, theme, keybindings) =>
      new VimEditor(tui, theme, keybindings),
    );
  });
}
