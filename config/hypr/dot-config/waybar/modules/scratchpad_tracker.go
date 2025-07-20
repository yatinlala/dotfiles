package main

import (
	"bytes"
	"fmt"
	"os/exec"
	"strings"
)

func checkRunning(process string) bool {
	cmd := exec.Command("pgrep", "-x", process)
	return cmd.Run() == nil
}

func checkRunningF(match string) bool {
	cmd := exec.Command("pgrep", "-f", match)
	return cmd.Run() == nil
}

func checkHyprClient(substr string) bool {
	cmd := exec.Command("hyprctl", "clients")
	out, err := cmd.Output()
	if err != nil {
		return false
	}
	return bytes.Contains(out, []byte(substr))
}

func main() {
	output := strings.Builder{}

	// Uncomment if you want this
	// if checkRunning("spotify") {
	// 	output.WriteString("  ")
	// }
	if checkRunning("spotifyd") {
		output.WriteString(" 🎶")
	}
	if checkRunning("signal-desktop") {
		output.WriteString(" 📞")
	}
	if checkHyprClient("brave-pdigihnmoiplkhocekidmdcmhchhdpjo-Default") {
		output.WriteString(" ✅")
	}
	if checkRunningF(`/usr/lib/electron[0-9]*/electron /usr/lib/obsidian/app.asar`) {
		output.WriteString(" 💎")
	}
	if checkRunningF("nerd-dictation begin") {
		output.WriteString(" 🗣️")
	}

	output.WriteString(" ")
	fmt.Println(output.String())
}
