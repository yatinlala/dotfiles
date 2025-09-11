#define _POSIX_C_SOURCE 199309L

#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

// Function to check if hypridle process is running
int is_hypridle_running(void) {
  DIR *proc_dir = opendir("/proc");
  if (!proc_dir)
    return 0;

  struct dirent *entry;
  char name[256];
  FILE *file;
  char path[512];

  while ((entry = readdir(proc_dir)) != NULL) {
    int pid = atoi(entry->d_name);
    if (pid <= 0)
      continue;

    snprintf(path, sizeof(path), "/proc/%d/comm", pid);
    file = fopen(path, "r");
    if (!file)
      continue;

    if (fgets(name, sizeof(name), file)) {
      char *newline = strchr(name, '\n');
      if (newline)
        *newline = '\0';
      if (strcmp(name, "hypridle") == 0) {
        fclose(file);
        closedir(proc_dir);
        return 1;
      }
    }
    fclose(file);
  }

  closedir(proc_dir);
  return 0;
}

// Function to handle toggle action
void toggle_hypridle(void) {
  if (is_hypridle_running()) {
    // Kill hypridle
    system("pkill -x hypridle");
  } else {
    // Start hypridle in background
    system("hypridle &");
  }
}

void sleep_ms(long milliseconds) {
  struct timespec ts;
  ts.tv_sec = milliseconds / 1000;
  ts.tv_nsec = (milliseconds % 1000) * 1000000;
  nanosleep(&ts, NULL);
}

int main(int argc, char *argv[]) {
  // Check if this is a toggle request
  if (argc > 1 && strcmp(argv[1], "toggle") == 0) {
    toggle_hypridle();
    return 0;
  }

  // Disable buffering on stdout to ensure immediate output
  setbuf(stdout, NULL);

  // Continuous loop with half-second intervals
  while (1) {
    if (is_hypridle_running()) {
      printf("😴\n");
    } else {
      printf("💥\n");
    }
    fflush(stdout);

    // Sleep for 500 milliseconds (half second)
    sleep_ms(500);
  }

  return 0;
}
