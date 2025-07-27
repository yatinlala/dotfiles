#include <cjson/cJSON.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

#define BUFFER_SIZE 4096
#define CMD_SIZE 256

// Execute command and return output
char *execute_command(const char *cmd) {
  FILE *fp = popen(cmd, "r");
  if (fp == NULL) {
    return NULL;
  }

  char *output = malloc(BUFFER_SIZE);
  size_t total_size = 0;
  size_t buffer_size = BUFFER_SIZE;

  while (fgets(output + total_size, buffer_size - total_size, fp) != NULL) {
    total_size = strlen(output);
    if (total_size >= buffer_size - 1) {
      buffer_size *= 2;
      output = realloc(output, buffer_size);
    }
  }

  pclose(fp);
  return output;
}

// Execute hyprctl dispatch command
void hyprctl_dispatch(const char *action) {
  char cmd[CMD_SIZE];
  snprintf(cmd, sizeof(cmd), "hyprctl dispatch %s", action);
  system(cmd);
}

// Check if string contains substring
int contains_string(const char *haystack, const char *needle) {
  return strstr(haystack, needle) != NULL;
}

// Get JSON array length
int get_json_array_length(cJSON *array) {
  if (!cJSON_IsArray(array))
    return 0;
  return cJSON_GetArraySize(array);
}

int main(int argc, char *argv[]) {
  if (argc != 2) {
    fprintf(stderr, "Usage: %s <direction>\n", argv[0]);
    return 1;
  }

  char *direction = argv[1];

  // Get active window info
  char *activewindow_output = execute_command("hyprctl activewindow");
  char *activewindow_j = execute_command("hyprctl activewindow -j");

  if (!activewindow_output || !activewindow_j) {
    fprintf(stderr, "Failed to get active window info\n");
    return 1;
  }

  // Parse JSON
  cJSON *active_json = cJSON_Parse(activewindow_j);
  if (!active_json) {
    fprintf(stderr, "Failed to parse active window JSON\n");
    free(activewindow_output);
    free(activewindow_j);
    return 1;
  }

  // Check if window is grouped
  cJSON *grouped = cJSON_GetObjectItem(active_json, "grouped");
  int is_grouped =
      grouped && cJSON_IsArray(grouped) && cJSON_GetArraySize(grouped) > 0;

  if (!is_grouped) {
    // No group, just move focus normally
    char cmd[CMD_SIZE];
    snprintf(cmd, sizeof(cmd), "movefocus %s", direction);
    hyprctl_dispatch(cmd);
  } else {
    // Window is grouped, handle special logic
    cJSON *address_json = cJSON_GetObjectItem(active_json, "address");
    if (!address_json || !cJSON_IsString(address_json)) {
      fprintf(stderr, "Failed to get window address\n");
      cJSON_Delete(active_json);
      free(activewindow_output);
      free(activewindow_j);
      return 1;
    }

    char *full_address = cJSON_GetStringValue(address_json);
    char window_id[64];
    // Remove "0x" prefix (first 2 characters)
    strncpy(window_id, full_address + 2, sizeof(window_id) - 1);
    window_id[sizeof(window_id) - 1] = '\0';

    // Get workspace info
    char *workspace_j = execute_command("hyprctl activeworkspace -j");
    if (!workspace_j) {
      fprintf(stderr, "Failed to get workspace info\n");
      cJSON_Delete(active_json);
      free(activewindow_output);
      free(activewindow_j);
      return 1;
    }

    cJSON *workspace_json = cJSON_Parse(workspace_j);
    if (!workspace_json) {
      fprintf(stderr, "Failed to parse workspace JSON\n");
      cJSON_Delete(active_json);
      free(activewindow_output);
      free(activewindow_j);
      free(workspace_j);
      return 1;
    }

    cJSON *workspace_id_json = cJSON_GetObjectItem(workspace_json, "id");
    if (!workspace_id_json || !cJSON_IsNumber(workspace_id_json)) {
      fprintf(stderr, "Failed to get workspace id\n");
      cJSON_Delete(active_json);
      cJSON_Delete(workspace_json);
      free(activewindow_output);
      free(activewindow_j);
      free(workspace_j);
      return 1;
    }

    int workspace_id = cJSON_GetNumberValue(workspace_id_json);

    // Get clients info
    char *clients_j = execute_command("hyprctl clients -j");
    if (!clients_j) {
      fprintf(stderr, "Failed to get clients info\n");
      cJSON_Delete(active_json);
      cJSON_Delete(workspace_json);
      free(activewindow_output);
      free(activewindow_j);
      free(workspace_j);
      return 1;
    }

    cJSON *clients_json = cJSON_Parse(clients_j);
    if (!clients_json || !cJSON_IsArray(clients_json)) {
      fprintf(stderr, "Failed to parse clients JSON\n");
      cJSON_Delete(active_json);
      cJSON_Delete(workspace_json);
      free(activewindow_output);
      free(activewindow_j);
      free(workspace_j);
      free(clients_j);
      return 1;
    }

    // Count visible windows in current workspace
    int visible_count = 0;
    cJSON *client = NULL;
    cJSON_ArrayForEach(client, clients_json) {
      cJSON *client_workspace = cJSON_GetObjectItem(client, "workspace");
      cJSON *client_hidden = cJSON_GetObjectItem(client, "hidden");

      if (client_workspace && cJSON_IsObject(client_workspace) &&
          client_hidden && cJSON_IsBool(client_hidden)) {

        cJSON *client_ws_id = cJSON_GetObjectItem(client_workspace, "id");
        if (client_ws_id && cJSON_IsNumber(client_ws_id) &&
            cJSON_GetNumberValue(client_ws_id) == workspace_id &&
            !cJSON_IsTrue(client_hidden)) {
          visible_count++;
        }
      }
    }

    // Handle direction-specific logic
    if (strcmp(direction, "r") == 0) {
      if (visible_count == 1) {
        hyprctl_dispatch("changegroupactive f");
      } else {
        // Check if window_id appears at end of line (simulating grep
        // "$window_id$")
        char *line_start = activewindow_output;
        char *found_pos = NULL;
        int is_at_end_of_line = 0;

        // Find all occurrences of window_id
        while ((found_pos = strstr(line_start, window_id)) != NULL) {
          // Check if this occurrence is at end of line
          char *after_id = found_pos + strlen(window_id);
          if (*after_id == '\n' || *after_id == '\0') {
            is_at_end_of_line = 1;
            break;
          }
          line_start = found_pos + 1;
        }

        if (is_at_end_of_line) {
          hyprctl_dispatch("movefocus r");
        } else {
          hyprctl_dispatch("changegroupactive f");
        }
      }
    } else if (strcmp(direction, "l") == 0) {
      if (visible_count == 1) {
        hyprctl_dispatch("changegroupactive b");
      } else {
        // Check if window_id appears after ": " (simulating grep ":
        // $window_id")
        char search_pattern[128];
        snprintf(search_pattern, sizeof(search_pattern), ": %s", window_id);

        if (contains_string(activewindow_output, search_pattern)) {
          hyprctl_dispatch("movefocus l");
        } else {
          hyprctl_dispatch("changegroupactive b");
        }
      }
    } else {
      // Other directions, just move focus
      char cmd[CMD_SIZE];
      snprintf(cmd, sizeof(cmd), "movefocus %s", direction);
      hyprctl_dispatch(cmd);
    }

    // Cleanup
    cJSON_Delete(clients_json);
    free(clients_j);
    cJSON_Delete(workspace_json);
    free(workspace_j);
  }

  // Cleanup
  cJSON_Delete(active_json);
  free(activewindow_output);
  free(activewindow_j);

  return 0;
}
