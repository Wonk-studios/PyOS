#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "setup.h"

void setup() {
    char section[50], key[50], value[50];

    printf("Enter section (bootloader/kernel): ");
    scanf("%49s", section);
    printf("Enter key (show_message/verbose_mode): ");
    scanf("%49s", key);
    printf("Enter value (true/false): ");
    scanf("%49s", value);

    modify_config(section, key, value);
}

void modify_config(const char *section, const char *key, const char *value) {
    FILE *file = fopen("config.ini", "r+");
    if (!file) {
        perror("fopen");
        return;
    }

    char line[256];
    char new_content[1024] = "";
    bool in_section = false;

    while (fgets(line, sizeof(line), file)) {
        if (line[0] == '[') {
            in_section = (strncmp(line + 1, section, strlen(section)) == 0);
        }

        if (in_section && strstr(line, key)) {
            snprintf(line, sizeof(line), "%s=%s\n", key, value);
            in_section = false;
        }

        strcat(new_content, line);
    }

    freopen("config.ini", "w", file);
    fputs(new_content, file);
    fclose(file);
}
