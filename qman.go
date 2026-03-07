package main

import (
	"bufio"
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"os/exec"
	"strings"
	"time"
)

type generateChunk struct {
	Response string `json:"response"`
	Done     bool   `json:"done"`
}

type generateRequest struct {
	Model  string `json:"model"`
	Prompt string `json:"prompt"`
	Stream bool   `json:"stream"`
}

const (
	defaultModel = "qwen3:0.6b"
	defaultHost  = "http://localhost:11434"
	maxManChars  = 6000
)

func main() {
	verbose, cmd, question := parseArgs(os.Args)
	if cmd == "" || question == "" {
		usage()
		os.Exit(1)
	}

	model := getenvDefault("QMAN_MODEL", defaultModel)
	host := getenvDefault("OLLAMA_HOST", defaultHost)

	if err := ensureManPage(cmd); err != nil {
		fmt.Fprintf(os.Stderr, "qmans: %v\n", err)
		os.Exit(1)
	}

	if err := ensureOllama(host); err != nil {
		fmt.Fprintf(os.Stderr, "qmans: %v\n", err)
		os.Exit(1)
	}

	if err := ensureModel(model); err != nil {
		fmt.Fprintf(os.Stderr, "qmans: %v\n", err)
		os.Exit(1)
	}

	man, err := fetchManPage(cmd)
	if err != nil {
		fmt.Fprintf(os.Stderr, "qmans: %v\n", err)
		os.Exit(1)
	}

	prompt := buildPrompt(cmd, question, man, verbose)

	if err := streamGenerate(host, model, prompt, os.Stdout); err != nil {
		fmt.Fprintf(os.Stderr, "qmans: %v\n", err)
		os.Exit(1)
	}
	fmt.Fprintln(os.Stdout)
}

func usage() {
	fmt.Fprintln(os.Stderr, "Usage: qmans [-v] <command> <question...>")
	fmt.Fprintln(os.Stderr, "Example: qmans grep how do i only print filenames")
	fmt.Fprintln(os.Stderr, "         qmans -v grep how do i only print filenames")
}

func parseArgs(args []string) (bool, string, string) {
	verbose := false
	pos := 1
	if len(args) > 1 && args[1] == "-v" {
		verbose = true
		pos++
	}
	if len(args) <= pos+1 {
		return verbose, "", ""
	}
	cmd := args[pos]
	question := strings.Join(args[pos+1:], " ")
	return verbose, cmd, question
}

func getenvDefault(key, def string) string {
	v := os.Getenv(key)
	if v == "" {
		return def
	}
	return v
}

func ensureManPage(cmd string) error {
	c := exec.Command("man", "-w", cmd)
	if err := c.Run(); err != nil {
		return fmt.Errorf("no man page found for '%s'", cmd)
	}
	return nil
}

func ensureOllama(host string) error {
	if ok := ollamaHealthy(host); ok {
		return nil
	}
	if err := startOllama(); err != nil {
		return err
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	for {
		if ollamaHealthy(host) {
			return nil
		}
		select {
		case <-ctx.Done():
			return errors.New("failed to start Ollama")
		case <-time.After(500 * time.Millisecond):
		}
	}
}

func ollamaHealthy(host string) bool {
	url := strings.TrimRight(host, "/") + "/api/tags"
	resp, err := http.Get(url)
	if err != nil {
		return false
	}
	defer resp.Body.Close()
	return resp.StatusCode >= 200 && resp.StatusCode < 300
}

func startOllama() error {
	if _, err := exec.LookPath("xdg-launch"); err != nil {
		return errors.New("xdg-launch not found in PATH")
	}
	cmd := exec.Command("xdg-launch", "ollama", "serve")
	cmd.Stdout = nil
	cmd.Stderr = nil
	if err := cmd.Start(); err != nil {
		return fmt.Errorf("failed to start Ollama: %w", err)
	}
	return nil
}

func ensureModel(model string) error {
	base := modelBase(model)
	out, err := exec.Command("ollama", "list").Output()
	if err != nil {
		return fmt.Errorf("failed to list models: %w", err)
	}
	scanner := bufio.NewScanner(bytes.NewReader(out))
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "NAME ") {
			continue
		}
		fields := strings.Fields(line)
		if len(fields) == 0 {
			continue
		}
		name := fields[0]
		if strings.HasPrefix(name, base) {
			return nil
		}
	}
	if err := scanner.Err(); err != nil {
		return fmt.Errorf("failed to read model list: %w", err)
	}

	pull := exec.Command("ollama", "pull", model)
	pull.Stdout = os.Stderr
	pull.Stderr = os.Stderr
	if err := pull.Run(); err != nil {
		return fmt.Errorf("failed to pull model %s: %w", model, err)
	}
	return nil
}

func modelBase(model string) string {
	parts := strings.SplitN(model, ":", 2)
	return parts[0]
}

func fetchManPage(cmd string) (string, error) {
	manCmd := exec.Command("man", cmd)
	colCmd := exec.Command("col", "-bx")

	pipe, err := manCmd.StdoutPipe()
	if err != nil {
		return "", err
	}
	colCmd.Stdin = pipe

	var out bytes.Buffer
	colCmd.Stdout = &out
	colCmd.Stderr = os.Stderr

	if err := manCmd.Start(); err != nil {
		return "", err
	}
	if err := colCmd.Start(); err != nil {
		return "", err
	}

	if err := manCmd.Wait(); err != nil {
		return "", err
	}
	if err := colCmd.Wait(); err != nil {
		return "", err
	}

	text := out.String()
	if len(text) > maxManChars {
		text = text[:maxManChars]
	}
	return text, nil
}

func buildPrompt(cmd, question, man string, verbose bool) string {
	if verbose {
		return fmt.Sprintf(
			"You are a helpful Unix command reference. Answer the user's question about the `%s` command using the man page below. Give a thorough explanation including relevant flags, usage examples, and any important caveats.\n\nMAN PAGE for %s:\n%s\n\nQuestion: %s",
			cmd, cmd, man, question,
		)
	}

	return fmt.Sprintf(
		"You are a helpful Unix command reference. Answer the user's question about the `%s` command using the man page below. Answer in one line with as few words as possible. Return only the minimal command or flag(s).\n\nMAN PAGE for %s:\n%s\n\nQuestion: %s",
		cmd, cmd, man, question,
	)
}

func streamGenerate(host, model, prompt string, w io.Writer) error {
	url := strings.TrimRight(host, "/") + "/api/generate"
	body, err := json.Marshal(generateRequest{Model: model, Prompt: prompt, Stream: true})
	if err != nil {
		return err
	}

	req, err := http.NewRequest("POST", url, bytes.NewReader(body))
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json")

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		return fmt.Errorf("ollama returned status %s", resp.Status)
	}

	scanner := bufio.NewScanner(resp.Body)
	buf := make([]byte, 0, 64*1024)
	scanner.Buffer(buf, 1024*1024)
	for scanner.Scan() {
		line := scanner.Bytes()
		if len(bytes.TrimSpace(line)) == 0 {
			continue
		}
		var chunk generateChunk
		if err := json.Unmarshal(line, &chunk); err != nil {
			continue
		}
		if chunk.Done {
			continue
		}
		if chunk.Response != "" {
			if _, err := io.WriteString(w, chunk.Response); err != nil {
				return err
			}
		}
	}
	if err := scanner.Err(); err != nil {
		return err
	}
	return nil
}
