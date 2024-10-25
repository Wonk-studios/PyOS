#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LENGTH 256
#define INI_FILE_PATH "root/usr/setup/settings.ini"
#define TEMP_FILE_PATH "root/usr/setup/temp.ini"

void display_settings() {
    FILE *file = fopen(INI_FILE_PATH, "r");
    if (file == NULL) {
        perror("Error opening file");
        return;
    }

    char line[MAX_LINE_LENGTH];
    while (fgets(line, sizeof(line), file)) {
        printf("%s", line);
    }

    fclose(file);
}

void modify_setting() {
    char section[MAX_LINE_LENGTH], key[MAX_LINE_LENGTH], value[MAX_LINE_LENGTH];
    printf("Enter the section: ");
    scanf("%s", section);
    printf("Enter the key: ");
    scanf("%s", key);
    printf("Enter the new value: ");
    scanf("%s", value);

    FILE *file = fopen(INI_FILE_PATH, "r");
    if (file == NULL) {
        perror("Error opening file");
        return;
    }

    FILE *temp = fopen(TEMP_FILE_PATH, "w");
    if (temp == NULL) {
        perror("Error opening temp file");
        fclose(file);
        return;
    }

    char line[MAX_LINE_LENGTH];
    int section_found = 0, key_found = 0;
    while (fgets(line, sizeof(line), file)) {
        if (line[0] == '[' && strstr(line, section)) {
            section_found = 1;
        }

        if (section_found && strstr(line, key)) {
            fprintf(temp, "%s = %s\n", key, value);
            key_found = 1;
            section_found = 0;
        } else {
            fprintf(temp, "%s", line);
        }
    }

    if (!key_found) {
        fprintf(temp, "[%s]\n%s = %s\n", section, key, value);
    }

    fclose(file);
    fclose(temp);

    remove(INI_FILE_PATH);
    rename(TEMP_FILE_PATH, INI_FILE_PATH);
}

void add_pointer() {
    char key[MAX_LINE_LENGTH], value[MAX_LINE_LENGTH];
    printf("Enter the pointer key: ");
    scanf("%s", key);
    printf("Enter the pointer value: ");
    scanf("%s", value);

    FILE *file = fopen(INI_FILE_PATH, "a");
    if (file == NULL) {
        perror("Error opening file");
        return;
    }

    fprintf(file, "pointer%s = %s\n", key, value);
    fclose(file);
}

void remove_pointer() {
    char key[MAX_LINE_LENGTH];
    printf("Enter the pointer key to remove: ");
    scanf("%s", key);

    FILE *file = fopen(INI_FILE_PATH, "r");
    if (file == NULL) {
        perror("Error opening file");
        return;
    }

    FILE *temp = fopen(TEMP_FILE_PATH, "w");
    if (temp == NULL) {
        perror("Error opening temp file");
        fclose(file);
        return;
    }

    char line[MAX_LINE_LENGTH];
    int section_found = 0;
    while (fgets(line, sizeof(line), file)) {
        if (line[0] == '[' && strstr(line, "Pointers")) {
            section_found = 1;
        }

        if (section_found && strstr(line, key)) {
            continue;
        } else {
            fprintf(temp, "%s", line);
        }
    }

    fclose(file);
    fclose(temp);

    remove(INI_FILE_PATH);
    rename(TEMP_FILE_PATH, INI_FILE_PATH);
}

int main() {
    while (1) {
        printf("Current settings:\n");
        display_settings();

        printf("Options:\n");
        printf("1. Modify a setting\n");
        printf("2. Add a pointer\n");
        printf("3. Remove a pointer\n");
        printf("4. Save and exit\n");
        printf("5. Exit without saving\n");

        int choice;
        printf("Enter your choice: ");
        scanf("%d", &choice);

        if (choice == 1) {
            modify_setting();
        } else if (choice == 2) {
            add_pointer();
        } else if (choice == 3) {
            remove_pointer();
        } else if (choice == 4) {
            printf("Settings saved.\n");
            break;
        } else if (choice == 5) {
            break;
        } else {
            printf("Invalid choice!\n");
        }
    }

    return 0;
}
