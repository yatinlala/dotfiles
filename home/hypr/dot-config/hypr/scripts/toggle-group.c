#include <assert.h>
#include <cjson/cJSON.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#define BUFSIZE 4096

char *instance_signature;
char *xdg_runtime_dir;

void *hyprctl(char *msg, char *buffer) {
  char socket_path[108]; // max socketpath size, :Man 7 unix
  snprintf(socket_path, sizeof(socket_path), "%s/hypr/%s/.socket.sock",
           xdg_runtime_dir, instance_signature);
  int fd = socket(AF_UNIX, SOCK_STREAM, 0);
  if (fd == -1) {
    fprintf(stderr, "Failed to open socket. Aborting.\n");
    exit(1);
  }
  struct sockaddr_un remote_socket_addr = {0};
  remote_socket_addr.sun_family = AF_UNIX;
  strncpy(remote_socket_addr.sun_path, socket_path,
          sizeof(remote_socket_addr.sun_path) - 1);
  if (connect(fd, (struct sockaddr *)&remote_socket_addr,
              sizeof(remote_socket_addr)) == -1) {
    fprintf(stderr, "Failed to connect to remote socket. Aborting.\n");
    exit(1);
  }
  send(fd, msg, strlen(msg), 0);
  char *buf_playhead = &buffer[0];
  int read_size, returned_byte_count;
  returned_byte_count = 0;
  while ((read_size =
              read(fd, buf_playhead, BUFSIZE - returned_byte_count - 1)) > 0) {
    assert(returned_byte_count < BUFSIZE);
    buf_playhead += read_size;
    returned_byte_count += read_size;
  }
  buffer[returned_byte_count] = '\0';
  close(fd);
  return buffer;
}

typedef struct {
  char address[64];
  int at_x, at_y;
} WindowInfo;

int compare_windows(const void *a, const void *b) {
  WindowInfo *wa = (WindowInfo *)a;
  WindowInfo *wb = (WindowInfo *)b;

  // Sort by y first, then x (top-left to bottom-right)
  if (wa->at_y != wb->at_y) {
    return wa->at_y - wb->at_y;
  }
  return wa->at_x - wb->at_x;
}

int main() {
  instance_signature = getenv("HYPRLAND_INSTANCE_SIGNATURE");
  xdg_runtime_dir = getenv("XDG_RUNTIME_DIR");
  if (!instance_signature || !xdg_runtime_dir) {
    fprintf(stderr, "Necessary environment variable is unset. Aborting.\n");
    return 1;
  }

  char buffer[BUFSIZE];
  hyprctl("j/activewindow", buffer);

  int is_group = 0;
  cJSON *json = cJSON_Parse(buffer);
  assert(json);

  char current_window_address[64];
  strcpy(current_window_address,
         cJSON_GetStringValue(cJSON_GetObjectItem(json, "address")));

  cJSON *item_grouped = cJSON_GetObjectItem(json, "grouped");
  if (cJSON_IsArray(item_grouped)) {
    int array_size = cJSON_GetArraySize(item_grouped);
    if (array_size > 0) {
      is_group = 1;
    } else {
      is_group = 0;
    }
  }

  int workspace_id = cJSON_GetNumberValue(
      cJSON_GetObjectItem(cJSON_GetObjectItem(json, "workspace"), "id"));
  cJSON_Delete(json);

  if (is_group == 0) {
    hyprctl("dispatch togglegroup", buffer);
  } else if (is_group == 1) {
    // Get all clients
    memset(buffer, 0, BUFSIZE);
    hyprctl("j/clients", buffer);
    json = cJSON_Parse(buffer);

    if (cJSON_IsArray(json)) {
      int num_windows = cJSON_GetArraySize(json);
      WindowInfo *windows = malloc(num_windows * sizeof(WindowInfo));
      int window_count = 0;

      // Collect windows in the same workspace
      for (int i = 0; i < num_windows; i++) {
        cJSON *window = cJSON_GetArrayItem(json, i);
        int win_workspace_id = cJSON_GetNumberValue(cJSON_GetObjectItem(
            cJSON_GetObjectItem(window, "workspace"), "id"));

        if (workspace_id == win_workspace_id) {
          strcpy(windows[window_count].address,
                 cJSON_GetStringValue(cJSON_GetObjectItem(window, "address")));

          cJSON *at_array = cJSON_GetObjectItem(window, "at");
          windows[window_count].at_x =
              cJSON_GetNumberValue(cJSON_GetArrayItem(at_array, 0));
          windows[window_count].at_y =
              cJSON_GetNumberValue(cJSON_GetArrayItem(at_array, 1));

          window_count++;
        }
      }

      // Sort windows by position (top-left to bottom-right)
      qsort(windows, window_count, sizeof(WindowInfo), compare_windows);

      // Focus the first window (top-left)
      if (window_count > 0) {
        char focus_cmd[128];
        snprintf(focus_cmd, sizeof(focus_cmd),
                 "dispatch focuswindow address:%s", windows[0].address);
        hyprctl(focus_cmd, buffer);

        // Create group with togglegroup
        hyprctl("dispatch togglegroup", buffer);

        // Move all other windows into the group from left
        for (int i = 1; i < window_count; i++) {
          char focus_cmd[128];
          snprintf(focus_cmd, sizeof(focus_cmd),
                   "dispatch focuswindow address:%s", windows[i].address);
          hyprctl(focus_cmd, buffer);

          hyprctl("dispatch moveintogroup left", buffer);
        }

        // Refocus the original window
        char refocus_cmd[128];
        snprintf(refocus_cmd, sizeof(refocus_cmd),
                 "dispatch focuswindow address:%s", current_window_address);
        hyprctl(refocus_cmd, buffer);
      }

      free(windows);
    }
    cJSON_Delete(json);
  }

  return 0;
}
