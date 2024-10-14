#include "../C_headers/error_handling.h"

void handle_error(const char *message) {
    perror(message);
    log_error(message);
    exit(EXIT_FAILURE);
}

void log_error(const char *message) {
    FILE *log_file = fopen("/workspaces/PyOS-Pro-ED/PyOS/usr/interpret/error.log", "a");
    if (log_file == NULL) {
        perror("Error opening log file");
        exit(EXIT_FAILURE);
    }
    fprintf(log_file, "Error: %s\n", message);
    fclose(log_file);
}