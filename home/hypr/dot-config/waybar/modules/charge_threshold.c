#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

static int get_threshold(void) {
  FILE *command = popen("set_charge_threshold", "r");
  int threshold;

  if (command == NULL || fscanf(command, "%d", &threshold) != 1) {
    if (command != NULL)
      pclose(command);
    fprintf(stderr, "could not read charge threshold\n");
    exit(EXIT_FAILURE);
  }
  if (pclose(command) != 0)
    exit(EXIT_FAILURE);

  return threshold;
}

static void set_threshold(int threshold) {
  char value[4];
  snprintf(value, sizeof(value), "%d", threshold);

  pid_t child = fork();
  if (child == 0) {
    execlp("set_charge_threshold", "set_charge_threshold", value, NULL);
    perror("set_charge_threshold");
    _exit(127);
  }
  if (child < 0) {
    perror("fork");
    exit(EXIT_FAILURE);
  }

  int status;
  if (waitpid(child, &status, 0) < 0 || !WIFEXITED(status) ||
      WEXITSTATUS(status) != 0)
    exit(EXIT_FAILURE);
}

int main(int argc, char **argv) {
  if (argc > 2) {
    fprintf(stderr, "usage: %s [up|down]\n", argv[0]);
    return EXIT_FAILURE;
  }

  if (argc == 2) {
    int threshold = get_threshold();

    if (strcmp(argv[1], "up") == 0)
      threshold += 5;
    else if (strcmp(argv[1], "down") == 0)
      threshold -= 5;
    else {
      fprintf(stderr, "usage: %s [up|down]\n", argv[0]);
      return EXIT_FAILURE;
    }

    if (threshold > 100)
      threshold = 100;
    if (threshold < 5)
      threshold = 5;
    set_threshold(threshold);
  }

  printf("󰌾 %d%%\n", get_threshold());
  return EXIT_SUCCESS;
}
