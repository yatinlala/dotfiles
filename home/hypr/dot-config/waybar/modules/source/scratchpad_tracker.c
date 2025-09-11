#define _POSIX_C_SOURCE 199309L

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h> // <-- needed for WEXITSTATUS
#include <time.h>
#include <unistd.h>

void sleep_ms(long ms) {
  struct timespec ts;
  ts.tv_sec = ms / 1000;
  ts.tv_nsec = (ms % 1000) * 1000000;
  nanosleep(&ts, NULL);
}

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
    strcat(out, "📞");
  }
  if (run_command("hyprctl clients | grep -q "
                  "brave-pdigihnmoiplkhocekidmdcmchhdpjo-Default")) {
    strcat(out, "✅");
  }
  if (run_command("pgrep -f '/usr/lib/obsidian/app.asar' >/dev/null")) {
    strcat(out, "💎");
  }
  // if (run_command("pgrep -f 'nerd-dictation begin' >/dev/null")) {
  //   strcat(out, "🗣️");
  // }

  strcat(out, " ");
}

int main(void) {
  char output[256];
  setbuf(stdout, NULL);

  while (1) {
    generate_status(output, sizeof(output));
    printf("%s\n", output);
    fflush(stdout);
    sleep_ms(500);
  }
}
