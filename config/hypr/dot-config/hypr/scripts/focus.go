package main

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
)

type Window struct {
	Address string   `json:"address"`
	Grouped []string `json:"grouped"`
}

type Workspace struct {
	ID int `json:"id"`
}

type Client struct {
	Workspace struct {
		ID int `json:"id"`
	} `json:"workspace"`
	Hidden bool `json:"hidden"`
}

func hyprctl(args ...string) ([]byte, error) {
	cmd := exec.Command("hyprctl", args...)
	return cmd.Output()
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: focus <l|r|u|d>")
		os.Exit(1)
	}
	direction := os.Args[1]

	// Get active window info
	winData, err := hyprctl("activewindow", "-j")
	if err != nil {
		fmt.Println("Error getting active window:", err)
		os.Exit(1)
	}

	var activeWindow Window
	if err := json.Unmarshal(winData, &activeWindow); err != nil {
		fmt.Println("JSON parsing error:", err)
		os.Exit(1)
	}

	// Check if the window is grouped
	if len(activeWindow.Grouped) == 0 {
		hyprctl("dispatch", "movefocus", direction)
		return
	}

	// Get workspace info
	workspaceData, err := hyprctl("activeworkspace", "-j")
	if err != nil {
		fmt.Println("Error getting active workspace:", err)
		os.Exit(1)
	}

	var workspace Workspace
	if err := json.Unmarshal(workspaceData, &workspace); err != nil {
		fmt.Println("JSON parsing error:", err)
		os.Exit(1)
	}

	// Get all clients
	clientsData, err := hyprctl("clients", "-j")
	if err != nil {
		fmt.Println("Error getting clients:", err)
		os.Exit(1)
	}

	var clients []Client
	if err := json.Unmarshal(clientsData, &clients); err != nil {
		fmt.Println("JSON parsing error:", err)
		os.Exit(1)
	}

	// we are grouped at this point
	visibleWindowCount := 0
	for _, client := range clients {
		if client.Workspace.ID == workspace.ID && !client.Hidden {
			visibleWindowCount++
		}
	}

	if visibleWindowCount == 1 {
		if direction == "r" {
			hyprctl("dispatch", "changegroupactive", "f")
			return
		} else if direction == "l" {
			hyprctl("dispatch", "changegroupactive", "b")
			return
		} else {
			hyprctl("dispatch", "movefocus", direction)
			return
		}

	}

	fmt.Printf("addr: %s\n", activeWindow.Address)
	for i, addr := range activeWindow.Grouped {
		fmt.Printf("%d: %s\n", i, addr)
	}
	// there is a group and more than one visible window
	if direction == "r" {
		if activeWindow.Grouped[len(activeWindow.Grouped)-1] == activeWindow.Address {
			hyprctl("dispatch", "movefocus", "r")
		} else {
			hyprctl("dispatch", "changegroupactive", "f")
		}
	} else if direction == "l" {
		if activeWindow.Grouped[0] == activeWindow.Address {
			hyprctl("dispatch", "movefocus", "l")
		} else {
			hyprctl("dispatch", "changegroupactive", "b")
		}
	} else {
		hyprctl("dispatch", "movefocus", direction)
	}
}
