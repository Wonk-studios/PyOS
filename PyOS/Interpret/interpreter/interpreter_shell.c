#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_INPUT_SIZE 1024
#define MAX_TOKENS 64
#define TOKEN_DELIMITERS " \t\r\n\a"

// Function prototypes
void shell_loop();
void execute_command(char **args);
char* read_input();
char** parse_input(char *input);

// Shell command functions
int shell_load(char **args);
int shell_run(char **args);
int shell_exit(char **args);
int shell_help(char **args);

// List of shell commands
char *shell_str[] = {
    "load",
    "run",
    "exit",
    "help"
};

// Corresponding functions for shell commands
int (*shell_func[]) (char **) = {
    &shell_load,
    &shell_run,
    &shell_exit,
    &shell_help
};

// Number of shell commands
int num_shell_commands() {
    return sizeof(shell_str) / sizeof(char *);
}

// Shell command: load
int shell_load(char **args) {
    if (args[1] == NULL) {
        fprintf(stderr, "Expected argument to \"load\"\n");
        return 1;
    }
    printf("Loading file: %s\n", args[1]);
    // Add code to load the file
    return 1;
}

// Shell command: run
int shell_run(char **args) {
    printf("Running interpreter...\n");
    // Add code to run the interpreter
    return 1;
}

// Shell command: exit
int shell_exit(char **args) {
    return 0;
}

// Shell command: help
int shell_help(char **args) {
    printf("Simple Shell\n");
    printf("Built-in commands:\n");
    for (int i = 0; i < num_shell_commands(); i++) {
        printf("  %s\n", shell_str[i]);
    }
    return 1;
}

// Function to read a line of input from the user
char* read_input() {
    char *input = malloc(MAX_INPUT_SIZE);
    if (!input) {
        fprintf(stderr, "Allocation error\n");
        exit(EXIT_FAILURE);
    }

    if (fgets(input, MAX_INPUT_SIZE, stdin) == NULL) {
        free(input);
        return NULL;
    }

    // Remove the newline character
    input[strcspn(input, "\n")] = '\0';
    return input;
}

// Function to parse the input into commands and arguments
char** parse_input(char *input) {
    int position = 0;
    char **tokens = malloc(MAX_TOKENS * sizeof(char*));
    char *token;

    if (!tokens) {
        fprintf(stderr, "Allocation error\n");
        exit(EXIT_FAILURE);
    }

    token = strtok(input, TOKEN_DELIMITERS);
    while (token != NULL) {
        tokens[position] = token;
        position++;

        if (position >= MAX_TOKENS) {
            fprintf(stderr, "Too many tokens\n");
            exit(EXIT_FAILURE);
        }

        token = strtok(NULL, TOKEN_DELIMITERS);
    }
    tokens[position] = NULL;
    return tokens;
}

// Function to execute commands
void execute_command(char **args) {
    if (args[0] == NULL) {
        // Empty command
        return;
    }

    for (int i = 0; i < num_shell_commands(); i++) {
        if (strcmp(args[0], shell_str[i]) == 0) {
            if ((*shell_func[i])(args) == 0) {
                exit(0);
            }
            return;
        }
    }

    // If the command is not recognized, print an error
    printf("Unknown command: %s\n", args[0]);
}

// Main shell loop
void shell_loop() {
    char *input;
    char **args;
    int status = 1;

    do {
        printf("> ");
        input = read_input();
        args = parse_input(input);
        status = execute_command(args);

        free(input);
        free(args);
    } while (status);
}

int main() {
    // Run the shell loop
    shell_loop();
    return 0;
}