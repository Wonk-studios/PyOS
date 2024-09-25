#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_INPUT_SIZE 1024
#define MAX_TOKENS 64
#define TOKEN_DELIMITERS " \t\r\n\a"

// Function prototypes
void terminal_loop();
void execute_command(char **args);
char* read_input();
char** parse_input(char *input);

// Terminal command functions
int terminal_asm(char **args);
int terminal_exit(char **args);
int terminal_help(char **args);

// List of terminal commands
char *terminal_str[] = {
    "asm",
    "exit",
    "help"
};

// Corresponding functions for terminal commands
int (*terminal_func[]) (char **) = {
    &terminal_asm,
    &terminal_exit,
    &terminal_help
};

// Number of terminal commands
int num_terminal_commands() {
    return sizeof(terminal_str) / sizeof(char *);
}

// Terminal command: asm
int terminal_asm(char **args) {
    if (args[1] == NULL) {
        fprintf(stderr, "Expected argument to \"asm\"\n");
        return 1;
    }
    printf("Executing assembly command: %s\n", args[1]);
    execute_assembly_command(args[1]);
    return 1;
}

void execute_assembly_command(const char *command) {
    char instr[16], arg1[16], arg2[16];
    int num_args = sscanf(command, "%15s %15s %15s", instr, arg1, arg2);

    if (num_args < 1) {
        printf("Invalid assembly command: %s\n", command);
        return;
    }

    if (strcmp(instr, "nop") == 0) {
        __asm__ __volatile__("nop");
    } else if (strcmp(instr, "hlt") == 0) {
        __asm__ __volatile__("hlt");
    } else if (strcmp(instr, "cli") == 0) {
        __asm__ __volatile__("cli");
    } else if (strcmp(instr, "sti") == 0) {
        __asm__ __volatile__("sti");
    } else if (strcmp(instr, "mov") == 0 && num_args == 3) {
        if (strcmp(arg1, "ax") == 0 && strcmp(arg2, "bx") == 0) {
            __asm__ __volatile__("mov %bx, %ax");
        } else if (strcmp(arg1, "bx") == 0 && strcmp(arg2, "ax") == 0) {
            __asm__ __volatile__("mov %ax, %bx");
        } else if (strcmp(arg1, "ax") == 0) {
            int value = atoi(arg2);
            __asm__ __volatile__("mov %0, %%ax" : : "r"(value));
        } else if (strcmp(arg1, "bx") == 0) {
            int value = atoi(arg2);
            __asm__ __volatile__("mov %0, %%bx" : : "r"(value));
        } else {
            printf("Unsupported mov command: %s %s %s\n", instr, arg1, arg2);
        }
    } else if (strcmp(instr, "add") == 0 && num_args == 3) {
        if (strcmp(arg1, "ax") == 0 && strcmp(arg2, "bx") == 0) {
            __asm__ __volatile__("add %bx, %ax");
        } else if (strcmp(arg1, "bx") == 0 && strcmp(arg2, "ax") == 0) {
            __asm__ __volatile__("add %ax, %bx");
        } else {
            printf("Unsupported add command: %s %s %s\n", instr, arg1, arg2);
        }
    } else if (strcmp(instr, "sub") == 0 && num_args == 3) {
        if (strcmp(arg1, "ax") == 0 && strcmp(arg2, "bx") == 0) {
            __asm__ __volatile__("sub %bx, %ax");
        } else if (strcmp(arg1, "bx") == 0 && strcmp(arg2, "ax") == 0) {
            __asm__ __volatile__("sub %ax, %bx");
        } else {
            printf("ILLIGAL SUB COMMAND: %s %s %s\n", instr, arg1, arg2);
        }
    } else {
        printf("ILLEGAL OR UNSUPPORTED COMMAND: %s\n", command);
    }
}

// Terminal command: exit
int terminal_exit(char **args) {
    return 0;
}

// Terminal command: help
int terminal_help(char **args) {
    printf("PYOS Kernel Assembly terminal\n");
    printf("Built-in commands:\n");
    for (int i = 0; i < num_terminal_commands(); i++) {
        printf("  %s\n", terminal_str[i]);
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
        fprintf(stderr, "ALLOCATION ERROR\n");
        exit(EXIT_FAILURE);
    }

    token = strtok(input, TOKEN_DELIMITERS);
    while (token != NULL) {
        tokens[position] = token;
        position++;

        if (position >= MAX_TOKENS) {
            fprintf(stderr, "LIMIT TOKENS\n");
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

    for (int i = 0; i < num_terminal_commands(); i++) {
        if (strcmp(args[0], terminal_str[i]) == 0) {
            if ((*terminal_func[i])(args) == 0) {
                exit(0);
            }
            return;
        }
    }

    // If the command is not recognized, print an error
    printf("ILLEGAL INPUT: %s\n", args[0]);
}

// Main terminal loop
void terminal_loop() {
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
    // Run the terminal loop
    terminal_loop();
    return 0;
}