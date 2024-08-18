#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <string.h>
#include <Python.h>

// Function prototype for plugin initialization
typedef void (*init_plugin_func)();

// Function to load and initialize a plugin
void load_plugin(const char *plugin_name) {
    char plugin_path[256];
    snprintf(plugin_path, sizeof(plugin_path), "/root/PyOS/interpret/plugins/%s/%s_plugin.so", plugin_name, plugin_name);

    void *handle = dlopen(plugin_path, RTLD_LAZY);
    if (!handle) {
        fprintf(stderr, "Error loading plugin %s: %s\n", plugin_name, dlerror());
        return;
    }

    // Find the initialization function for the plugin
    init_plugin_func init_plugin = (init_plugin_func) dlsym(handle, "init_plugin");
    if (!init_plugin) {
        fprintf(stderr, "Error loading init function for plugin %s: %s\n", plugin_name, dlerror());
        dlclose(handle);
        return;
    }

    // Call the plugin's initialization function
    init_plugin();
    printf("Plugin %s loaded successfully!\n", plugin_name);

    // Optionally keep the plugin loaded for further use
    // Call dlclose(handle) when the plugin is no longer needed.
}

// Function to execute a Python script
void run_script(const char *script_path) {
    FILE *fp = fopen(script_path, "r");
    if (!fp) {
        perror("Error opening script file");
        return;
    }

    // Initialize the Python interpreter
    Py_Initialize();

    // Load Pygame plugin if needed
    if (strstr(script_path, "pygame")) {
        load_plugin("pygame");
    }

    // Execute the script
    PyRun_SimpleFile(fp, script_path);

    // Clean up
    fclose(fp);
    Py_Finalize();
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <script_path>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    printf("Interpreter starting...\n");

    // Run the provided script
    run_script(argv[1]);

    printf("Interpreter finished execution.\n");
    return 0;
}
