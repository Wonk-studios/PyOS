#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>
#include "setup.h"

// Function prototypes
void shell_loop();

int main() {
    // Run the shell loop
    shell_loop();
    return 0;
}

void shell_loop() {
    char *input = NULL;
    size_t len = 0;
    ssize_t read;
    bool status = true;

    do {
        printf("> ");
        read = getline(&input, &len, stdin);
        if (read == -1) {
            perror("getline");
            exit(EXIT_FAILURE);
        }

        // Remove newline character
        input[strcspn(input, "\n")] = 0;

        // Check for the setup command
        if (strcmp(input, "setup") == 0) {
            setup();
        } else if (strcmp(input, "exit") == 0) {
            status = false;
        } else {
            printf("ILLEGAL: %s\n", input);
        }

        free(input);
        input = NULL;
    } while (status);
}
