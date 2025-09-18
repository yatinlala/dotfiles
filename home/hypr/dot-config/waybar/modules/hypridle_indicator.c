#define _POSIX_C_SOURCE 199309L
#include <assert.h>
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int yl_strlen(const char *string) {
  assert(string != NULL);
  int i = 0;
  while (string[i] != '\0') {
    i++;
  }
  return i;
}

int yl_str_is_equal(const char *string1, const char *string2) {
  assert(string1 != NULL && string2 != NULL);
  int i = 0;
  while (string1[i] != '\0' && string2[i] != '\0') {
    if (string1[i] != string2[i]) {
      return 0;
    }
    i++;
  }
  return string1[i] == string2[i];
}

int yl_str_occurences_of(const char *string, const char *chars) {
  assert(string != NULL);
  int i = 0;
  int occurences = 0;
  while (string[i] != '\0') {
    int j = 0;
    while (chars[j] != '\0') {
      if (string[i] == chars[j]) {
        occurences++;
        break;
      }
      j++;
    }
    i++;
  }
  return occurences;
}

int pgrep(const char *process_name) {
  DIR *proc_dir;
  struct dirent *entry;
  FILE *comm_file;
  char path[256];
  char comm[256];

  proc_dir = opendir("/proc");
  if (proc_dir == NULL) {
    perror("opendir");
    return -1;
  }

  while ((entry = readdir(proc_dir)) != NULL) {
    // entries with only numbers in their name are process dirs
    if (yl_str_occurences_of(entry->d_name, "0123456789") !=
        yl_strlen(entry->d_name)) {
      continue;
    }

    snprintf(path, sizeof(path), "/proc/%s/comm", entry->d_name);

    comm_file = fopen(path, "r");
    if (comm_file == NULL) {
      continue;
    }

    if (fgets(comm, sizeof(comm), comm_file) != NULL) {
      // Remove newline
      size_t len = yl_strlen(comm);
      if (len > 0 && comm[len - 1] == '\n') {
        comm[len - 1] = '\0';
      }

      if (yl_str_is_equal(comm, process_name)) {
        fclose(comm_file);
        closedir(proc_dir);
        return 1;
      }
    }

    fclose(comm_file);
  }

  closedir(proc_dir);
  return 0;
}

int main(int argc, char **argv) {
  struct timespec sleep_time = {.tv_sec = 0, .tv_nsec = 500000000};
  int result;

  if (argc == 2 && yl_str_is_equal(argv[1], "toggle")) {
    result = pgrep("hypridle");
    if (result == -1) {
      fprintf(stderr, "Error checking process\n");
      return 1;
    } else if (result == 1) {
      system("pkill -x hypridle");
      return 0;
    } else {
      system("nohup hypridle >/dev/null 2>&1 &");
      return 0;
    }
  }

  while (1) {
    result = pgrep("hypridle");

    if (result == -1) {
      fprintf(stderr, "Error checking process\n");
      return 1;
    } else if (result == 1) {
      printf("😴\n");
    } else {
      printf("💥\n");
    }

    fflush(stdout);
    nanosleep(&sleep_time, NULL);
  }

  return 0;
}
