#ifndef INI_H
#define INI_H

#include <stdio.h>  // Include the stdio.h header file

/* Typedef for handler function pointer */
typedef int (*ini_handler)(void* user, const char* section, const char* name, const char* value);

/* Function to parse an INI file */
int ini_parse(const char* filename, ini_handler handler, void* user);

/* Function to parse an INI file from a string */
int ini_parse_string(const char* string, ini_handler handler, void* user);

/* Function to parse an INI file from a file pointer */
int ini_parse_file(FILE* file, ini_handler handler, void* user);

#endif /* INI_H */
