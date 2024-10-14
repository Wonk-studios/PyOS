#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LENGTH 256
#define INI_FILE_PATH "/workspaces/PyOS-Pro-ED/PyOS/usr/setup/settings.ini"

void read_default_script(char *script_name) {
    FILE *file = fopen(INI_FILE_PATH, "r");
    if (file == NULL) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }

    char line[MAX_LINE_LENGTH];
    int in_interpreter_section = 0;

    while (fgets(line, sizeof(line), file)) {
        if (strstr(line, "[Interpreter]")) {
            in_interpreter_section = 1;
        } else if (line[0] == '[') {
            in_interpreter_section = 0;
        }

        if (in_interpreter_section && strstr(line, "Default_script")) {
            char *equals_sign = strchr(line, '=');
            if (equals_sign) {
                strcpy(script_name, equals_sign + 1);
                // Remove any trailing newline or spaces
                script_name[strcspn(script_name, "\r\n")] = 0;
                script_name[strcspn(script_name, " ")] = 0;
            }
            break;
        }
    }

    fclose(file);
}

void run_script(const char *script_name) {
    char command[MAX_LINE_LENGTH + 10];
    snprintf(command, sizeof(command), "python3 %s", script_name);
    int result = system(command);
    if (result == -1) {
        perror("Error running script");
    }
}

int main() {
    char script_name[MAX_LINE_LENGTH] = {0};

    read_default_script(script_name);

    if (strlen(script_name) > 0) {
        printf("Running default script: %s\n", script_name);
        run_script(script_name);
    } else {
        printf("No default script found in the settings.ini file.\n");
    }

    return 0;
}