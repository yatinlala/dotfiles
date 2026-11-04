import fs from "node:fs/promises";
import { constants } from "node:fs";
import os from "node:os";
import path from "node:path";

/** Import only Pi-generated clipboard files; never expose the host temp directory. */
export async function importClipboardFiles(
	text: string,
	write: (guestPath: string, bytes: Buffer) => Promise<void>,
): Promise<string> {
	const temp = os.tmpdir();
	const escaped = temp.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
	const pattern = new RegExp(`${escaped}/pi-clipboard-[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}\\.(?:png|jpg|jpeg|gif|webp)(?![\\w./-])`, "g");
	for (const source of new Set(text.match(pattern) ?? [])) {
		let file;
		try {
			file = await fs.open(source, constants.O_RDONLY | constants.O_NOFOLLOW);
		} catch (error) {
			// Already imported, or a guest-only path in a later message.
			if ((error as NodeJS.ErrnoException).code === "ENOENT") continue;
			throw error;
		}
		try {
			const stat = await file.stat();
			if (!stat.isFile() || stat.size > 20 * 1024 * 1024) {
				throw new Error("Clipboard image must be a regular file under 20 MiB");
			}
			const guest = `/tmp/${path.basename(source)}`;
			await write(guest, await file.readFile());
			text = text.split(source).join(guest);
			// Delete only after a successful copy, and only if the source is unchanged.
			const current = await fs.lstat(source).catch(() => undefined);
			if (current?.ino === stat.ino && current.dev === stat.dev) {
				await fs.unlink(source).catch(() => undefined);
			}
		} finally {
			await file.close();
		}
	}
	return text;
}
