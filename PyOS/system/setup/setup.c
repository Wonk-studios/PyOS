#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LENGTH 256
#define INI_FILE_PATH "/system/setup/boot.ini"

typedef struct {
    char timeout[MAX_LINE_LENGTH];
    char default_OS[MAX_LINE_LENGTH];
    char verbose_mode[MAX_LINE_LENGTH];
    char CPU_architecture[MAX_LINE_LENGTH];
    char Boot_to[MAX_LINE_LENGTH];
    char Hyberfil_file[MAX_LINE_LENGTH];
} BootConfig;

void read_boot_configuration(BootConfig *config) {
    FILE *file = fopen(INI_FILE_PATH, "r");
    if (file == NULL) {
        perror("Error opening boot.ini file");
        exit(EXIT_FAILURE);
    }

    char line[MAX_LINE_LENGTH];
    char section[MAX_LINE_LENGTH] = {0};

    while (fgets(line, sizeof(line), file)) {
        if (line[0] == '[') {
            sscanf(line, "[%[^]]]", section);
        } else if (strstr(section, "General")) {
            if (strstr(line, "timeout")) {
                sscanf(line, "timeout=%s", config->timeout);
            } else if (strstr(line, "default_OS")) {
                sscanf(line, "default_OS=%s", config->default_OS);
            } else if (strstr(line, "verbose_mode")) {
                sscanf(line, "verbose_mode=%s", config->verbose_mode);
            }
        } else if (strstr(section, "Bootmanager")) {
            if (strstr(line, "CPU_architecture")) {
                sscanf(line, "CPU_architecture=%s", config->CPU_architecture);
            }
        } else if (strstr(section, "Kernel")) {
            if (strstr(line, "Boot_to")) {
                sscanf(line, "Boot_to=%s", config->Boot_to);
            } else if (strstr(line, "Hyberfil_file")) {
                sscanf(line, "Hyberfil_file=%s", config->Hyberfil_file);
            }
        }
    }

    fclose(file);
}

void write_boot_configuration(const BootConfig *config) {
    FILE *file = fopen(INI_FILE_PATH, "w");
    if (file == NULL) {
        perror("Error opening boot.ini file for writing");
        exit(EXIT_FAILURE);
    }

    fprintf(file, "[General]\n");
    fprintf(file, "timeout=%s\n", config->timeout);
    fprintf(file, "default_OS=%s\n", config->default_OS);
    fprintf(file, "verbose_mode=%s\n", config->verbose_mode);
    fprintf(file, "\n[Bootmanager]\n");
    fprintf(file, "CPU_architecture=%s\n", config->CPU_architecture);
    fprintf(file, "\n[Bootloader]\n");
    fprintf(file, "\n[Kernel]\n");
    fprintf(file, "Boot_to=%s\n", config->Boot_to);
    fprintf(file, "Hyberfil_file=%s\n", config->Hyberfil_file);

    fclose(file);
}

void modify_boot_configuration(BootConfig *config) {
    printf("Current Boot Configuration:\n");
    printf("1. Timeout: %s\n", config->timeout);
    printf("2. Default OS: %s\n", config->default_OS);
    printf("3. Verbose Mode: %s\n", config->verbose_mode);
    printf("4. CPU Architecture: %s\n", config->CPU_architecture);
    printf("5. Boot To: %s\n", config->Boot_to);
    printf("6. Hyberfil File: %s\n", config->Hyberfil_file);

    printf("\nEnter the number of the parameter you want to change (or 0 to exit): ");
    int choice;
    scanf("%d", &choice);

    char new_value[MAX_LINE_LENGTH];
    switch (choice) {
        case 1:
            printf("Enter new Timeout: ");
            scanf("%s", new_value);
            strcpy(config->timeout, new_value);
            break;
        case 2:
            printf("Enter new Default OS: ");
            scanf("%s", new_value);
            strcpy(config->default_OS, new_value);
            break;
        case 3:
            printf("Enter new Verbose Mode (True/False): ");
            scanf("%s", new_value);
            strcpy(config->verbose_mode, new_value);
            break;
        case 4:
            printf("Enter new CPU Architecture: ");
            scanf("%s", new_value);
            strcpy(config->CPU_architecture, new_value);
            break;
        case 5:
            printf("Enter new Boot To: ");
            scanf("%s", new_value);
            strcpy(config->Boot_to, new_value);
            break;
        case 6:
            printf("Enter new Hyberfil File: ");
            scanf("%s", new_value);
            strcpy(config->Hyberfil_file, new_value);
            break;
        case 0:
            return;
        default:
            printf("Invalid choice.\n");
            break;
    }
}

int main() {
    BootConfig config = {0};

    read_boot_configuration(&config);
    modify_boot_configuration(&config);
    write_boot_configuration(&config);

    return 0;
}