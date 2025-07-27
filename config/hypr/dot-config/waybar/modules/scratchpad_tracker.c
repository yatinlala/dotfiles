#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define MAX_OUTPUT_LEN 256
#define MAX_PATH_LEN 512
#define MAX_LINE_LEN 1024

// Function to read the command line of a process from /proc/pid/cmdline
int read_proc_cmdline(int pid, char *cmdline, size_t max_len) {
  char path[MAX_PATH_LEN];
  snprintf(path, sizeof(path), "/proc/%d/cmdline", pid);
  FILE *file = fopen(path, "r");
  if (!file)
    return 0;
  size_t len = fread(cmdline, 1, max_len - 1, file);
  fclose(file);
  if (len == 0)
    return 0;
  cmdline[len] = '\0';
  // Replace null bytes with spaces (cmdline uses null separators)
  for (size_t i = 0; i < len; i++) {
    if (cmdline[i] == '\0')
      cmdline[i] = ' ';
  }
  return 1;
}

// Function to get process name from /proc/pid/comm
int read_proc_name(int pid, char *name, size_t max_len) {
  char path[MAX_PATH_LEN];
  snprintf(path, sizeof(path), "/proc/%d/comm", pid);
  FILE *file = fopen(path, "r");
  if (!file)
    return 0;
  if (fgets(name, max_len, file)) {
    // Remove trailing newline
    char *newline = strchr(name, '\n');
    if (newline)
      *newline = '\0';
    fclose(file);
    return 1;
  }
  fclose(file);
  return 0;
}

// Function to check if a process with exact name exists
int check_process_exact(const char *process_name) {
  DIR *proc_dir = opendir("/proc");
  if (!proc_dir)
    return 0;
  struct dirent *entry;
  char name[256];
  while ((entry = readdir(proc_dir)) != NULL) {
    // Skip non-numeric directory names
    int pid = atoi(entry->d_name);
    if (pid <= 0)
      continue;
    if (read_proc_name(pid, name, sizeof(name))) {
      if (strcmp(name, process_name) == 0) {
        closedir(proc_dir);
        return 1;
      }
    }
  }
  closedir(proc_dir);
  return 0;
}

// Function to check if a process matching a pattern exists in command line
int check_process_cmdline_pattern(const char *pattern) {
  DIR *proc_dir = opendir("/proc");
  if (!proc_dir)
    return 0;
  struct dirent *entry;
  char cmdline[MAX_LINE_LEN];
  while ((entry = readdir(proc_dir)) != NULL) {
    // Skip non-numeric directory names
    int pid = atoi(entry->d_name);
    if (pid <= 0)
      continue;
    if (read_proc_cmdline(pid, cmdline, sizeof(cmdline))) {
      if (strstr(cmdline, pattern)) {
        closedir(proc_dir);
        return 1;
      }
    }
  }
  closedir(proc_dir);
  return 0;
}

// Function to check hyprctl output (still needs system call as it's IPC
// specific)
int check_hyprctl_grep(const char *pattern) {
  char command[512];
  snprintf(command, sizeof(command),
           "hyprctl clients | grep -q \"%s\" 2>/dev/null", pattern);
  int status = system(command);
  return WEXITSTATUS(status) == 0;
}

// Function to generate status output
void generate_status(char *output) {
  strcpy(output, " "); // Start with a space

  // Check for spotifyd process (exact name match)
  if (check_process_exact("spotifyd")) {
    strcat(output, "🎶 ");
  }

  // Check for signal-desktop process (exact name match)
  if (check_process_exact("signal-desktop")) {
    strcat(output, "📞");
  }

  // Check for brave window with specific ID (still uses hyprctl)
  if (check_hyprctl_grep("brave-pdigihnmoiplkhocekidmdcmchhdpjo-Default")) {
    strcat(output, "✅");
  }

  // Check for obsidian process (command line pattern match)
  if (check_process_cmdline_pattern("/usr/lib/obsidian/app.asar")) {
    strcat(output, "💎");
  }

  // Check for nerd-dictation process (command line pattern match)
  if (check_process_cmdline_pattern("nerd-dictation begin")) {
    strcat(output, "🗣️");
  }

  // Add trailing space
  strcat(output, " ");
}

int main() {
  char output[MAX_OUTPUT_LEN];

  // Disable buffering on stdout to ensure immediate output
  setbuf(stdout, NULL);

  // Continuous loop with half-second intervals
  while (1) {
    generate_status(output);
    printf("%s\n", output);
    fflush(stdout); // Explicitly flush output buffer

    // Sleep for 500 milliseconds (half second)
    usleep(500000);
  }

  return 0;
}
