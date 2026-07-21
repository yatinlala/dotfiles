/**
 * Approval-gated host shell access for sandboxed Pi sessions.
 *
 * The tool is available to the agent, but every command runs only after the
 * user approves that exact invocation. Non-interactive sessions fail closed.
 */

import { createBashTool, type ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	const hostCwd = process.cwd();
	const hostBash = createBashTool(hostCwd);

	pi.registerTool({
		...hostBash,
		name: "host_bash",
		label: "Host Bash (approval required)",
		description:
			"Run a shell command directly on the host, outside any sandbox or VM. Each call requires explicit user approval. Use only when the task needs host resources unavailable in the sandbox.",
		promptSnippet: "Run an explicitly approved shell command outside the sandbox on the host",
		promptGuidelines: [
			"Use host_bash only when the task requires a host resource unavailable inside the sandbox; prefer sandboxed tools otherwise.",
			"Before calling host_bash, use the narrowest command needed and expect the user to approve or deny that exact command.",
		],
		async execute(id, params, signal, onUpdate, ctx) {
			if (!ctx.hasUI) {
				throw new Error("Host command denied: no interactive UI is available for approval");
			}

			const approved = await ctx.ui.confirm(
				"Allow command on host?",
				[
					"This command will run outside the sandbox with your host user permissions.",
					`Working directory: ${hostCwd}`,
					"",
					params.command,
				].join("\n"),
				{ signal },
			);
			if (!approved) throw new Error("Host command denied by user");

			return hostBash.execute(id, params, signal, onUpdate);
		},
	});
}
