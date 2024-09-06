#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <string.h>
#include <Python.h>

// Function prototype for plugin initialization
typedef void (*init_plugin_func)();

// Function to log errors
void log_error(const char *message) {
    FILE *log_file = fopen("error_log.txt", "a");
    if (log_file == NULL) {
        fprintf(stderr, "Failed to open log file\n");
        exit(EXIT_FAILURE);
    }
    fprintf(log_file, "Error: %s\n", message);
    fclose(log_file);
}

// Function to load and initialize a plugin
void load_plugin(const char *plugin_name) {
    char plugin_path[256];
    snprintf(plugin_path, sizeof(plugin_path), "/root/PyOS/interpret/plugins/%s/%s_plugin.so", plugin_name, plugin_name);

    void *handle = dlopen(plugin_path, RTLD_LAZY);
    if (!handle) {
        log_error(dlerror());
        exit(EXIT_FAILURE);
    }

    init_plugin_func init_plugin = (init_plugin_func)dlsym(handle, "init_plugin");
    if (!init_plugin) {
        log_error(dlerror());
        dlclose(handle);
        exit(EXIT_FAILURE);
    }

    init_plugin();
    dlclose(handle);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        log_error("No plugin specified");
        fprintf(stderr, "Usage: %s <plugin_name>\n", argv[0]);
        return EXIT_FAILURE;
    }

    // Initialize Python interpreter
    Py_Initialize();
    if (!Py_IsInitialized()) {
        log_error("Failed to initialize Python interpreter");
        return EXIT_FAILURE;
    }

    // Load and initialize the plugin
    load_plugin(argv[1]);

    // Finalize Python interpreter
    if (Py_IsInitialized()) {
        Py_Finalize();
    } else {
        log_error("Python interpreter was not properly initialized");
    }

    return EXIT_SUCCESS;
}