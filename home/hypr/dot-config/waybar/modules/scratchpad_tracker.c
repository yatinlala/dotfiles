#define _POSIX_C_SOURCE 199309L

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h> // <-- needed for WEXITSTATUS
#include <time.h>
#include <unistd.h>

int run_command(const char *cmd) {
  int status = system(cmd);
  return (status != -1 && WEXITSTATUS(status) == 0);
}

void generate_status(char *out, size_t outlen) {
  out[0] = '\0';
  strcat(out, " ");

  if (run_command("pgrep -x spotifyd >/dev/null")) {
    strcat(out, "🎶 ");
  }
  if (run_command("pgrep -x signal-desktop >/dev/null")) {
    strcat(out, "  ");
  }
  if (run_command("hyprctl clients | grep -q "
                  "brave-pdigihnmoiplkhocekidmdcmhchhdpjo-Default")) {
    strcat(out, "  ");
  }
  if (run_command("hyprctl clients | grep -q "
                  "brave-fmgjjmmmlfnkbppncabfkddbjimcfncm-Default")) {
    strcat(out, " ");
  }
  if (run_command("hyprctl clients | grep -q "
                  "brave-magkoliahgffibhgfkmoealggombgknl-Default")) {
    strcat(out, "  ");
  }
  if (run_command("hyprctl clients | grep -q "
                  "brave-hnpfjngllnobngcgfapefoaidbinmjnm-Default")) {
    strcat(out, " ");
  }
  if (run_command("hyprctl clients | grep -q "
                  "brave-www.instagram.com__direct_inbox_-Default")) {
    strcat(out, " ");
  }

  if (run_command("pgrep -f '/usr/lib/electron[0-9]*/electron "
                  "/usr/lib/obsidian/app.asar' >/dev/null")) {
    strcat(out, " ");
  }
  // if (run_command("pgrep -f 'nerd-dictation begin' >/dev/null")) {
  //   strcat(out, "🗣️");
  // }

  // strcat(out, " ");
}

int main(void) {
  char output[256];
  struct timespec sleep_time = {.tv_sec = 0, .tv_nsec = 500000000};

  while (1) {
    generate_status(output, sizeof(output));
    printf("%s\n", output);
    fflush(stdout);
    nanosleep(&sleep_time, NULL);
  }
}
