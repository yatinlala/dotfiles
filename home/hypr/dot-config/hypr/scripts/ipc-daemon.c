#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

const int BUFFER_SIZE = 1024;

int main() {
  const char *instance_signature = getenv("HYPRLAND_INSTANCE_SIGNATURE");
  const char *xdg_runtime_dir = getenv("XDG_RUNTIME_DIR");
  if (!instance_signature || !xdg_runtime_dir) {
    fprintf(stderr, "Necessary environment variable is unset. Aborting.\n");
    return 1;
  }

  char socket_path[108]; // max socketpath size, :Man 7 unix
  snprintf(socket_path, sizeof(socket_path), "%s/hypr/%s/.socket2.sock",
           xdg_runtime_dir, instance_signature);

  int fd = socket(AF_UNIX, SOCK_STREAM, 0);
  if (fd == -1) {
    fprintf(stderr, "Failed to open socket. Aborting.\n");
    return 1;
  }

  struct sockaddr_un remote_socket_addr = {0};
  remote_socket_addr.sun_family = AF_UNIX;
  strncpy(remote_socket_addr.sun_path, socket_path,
          sizeof(remote_socket_addr.sun_path) - 1);

  if (connect(fd, (struct sockaddr *)&remote_socket_addr,
              sizeof(remote_socket_addr)) == -1) {
    fprintf(stderr, "Failed to connect to remote socket. Aborting.\n");
    return 1;
  }

  char buffer[BUFFER_SIZE];
  char line_buffer[BUFFER_SIZE + 1];
  int line_pos = 0;
  int returned_byte_count;
  int youtube_window_selected = 0;

  while ((returned_byte_count = read(fd, buffer, BUFFER_SIZE)) > 0) {
    for (int i = 0; i < returned_byte_count; i++) {
      if (buffer[i] == '\n') {
        line_buffer[line_pos] = '\0';

        if (strncmp(line_buffer, "monitorremovedv2>>", 18) == 0) {
          if (!strstr(line_buffer, "eDP-1,Lenovo Group Limited")) {
            system("hyprctl keyword monitor 'eDP-1,1920x1200@60,0x0,1'");
          }
        } else if (strncmp(line_buffer, "monitoraddedv2>>", 16) == 0) {
          char *edp_added = strstr(line_buffer, "eDP-1,Lenovo Group Limited");
          if (!edp_added) {
            system("hyprctl keyword monitor 'eDP-1,disable'");
          }
        }
        // else if (strncmp(line_buffer, "activewindow>>", 14) == 0) {
        //   char *found_zen = strstr(line_buffer, "YouTube — Zen Browser");
        //   char *found_brave = NULL;
        //   if (!found_zen) {
        //     found_brave = strstr(line_buffer, "YouTube - Brave");
        //   }
        //   if (found_zen || found_brave) {
        //     system("hyprshade on grayscale");
        //     youtube_window_selected = 1;
        //   }
        //   if (!found_zen && !found_brave && youtube_window_selected) {
        //     system("hyprshade off");
        //     youtube_window_selected = 0;
        //   }
        // }
        line_pos = 0;
        memset(line_buffer, 0, BUFFER_SIZE);

      } else {
        if (line_pos >= BUFFER_SIZE - 1) {
          fprintf(stderr, "Exceeded BUFFER_SIZE. Aborting.\n");
          return 1;
        }
        line_buffer[line_pos++] = buffer[i];
      }
    }
  }

  close(fd);
  return 0;
}
