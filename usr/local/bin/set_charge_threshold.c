#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
  const char *path =
      "/sys/class/power_supply/BAT0/charge_control_end_threshold";

  // No args: read and print current threshold
  if (argc == 1) {
    FILE *f = fopen(path, "r");
    if (!f) {
      perror("Error opening sysfs file");
      return 1;
    }
    long val;
    if (fscanf(f, "%ld", &val) != 1) {
      fprintf(stderr, "Error: could not read threshold value\n");
      fclose(f);
      return 1;
    }
    fclose(f);
    printf("%ld%%\n", val);
    return 0;
  }

  if (argc != 2) {
    fprintf(stderr, "Usage: %s [value]\n", argv[0]);
    return 1;
  }

  // Validate: must be a number between 1 and 100
  char *endptr;
  long val = strtol(argv[1], &endptr, 10);
  if (*endptr != '\0' || val < 1 || val > 100) {
    fprintf(stderr, "Error: value must be an integer between 1 and 100\n");
    return 1;
  }

  FILE *f = fopen(path, "w");
  if (!f) {
    perror("Error opening sysfs file");
    return 1;
  }

  fprintf(f, "%ld\n", val);
  fclose(f);

  printf("Set charge threshold to %ld%%\n", val);
  return 0;
}
