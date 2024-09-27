// src/wayland.c
#include <wayland-client.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../../include/ini.h"

static int verbose_mode = 0;

static int handler(void* user, const char* section, const char* name, const char* value) {
    if (strcmp(section, "kernel") == 0 && strcmp(name, "verbose_mode") == 0) {
        verbose_mode = strcmp(value, "true") == 0;
    }
    return 1;
}

static void parse_config() {
    if (ini_parse("config.ini", handler, NULL) < 0) {
        fprintf(stderr, "Can't load 'config.ini'\n");
        exit(1);
    }
}

static void registry_handler(void *data, struct wl_registry *registry, uint32_t id, const char *interface, uint32_t version) {
    if (verbose_mode) {
        printf("Got a registry event for %s id %d\n", interface, id);
    }
}

static const struct wl_registry_listener registry_listener = {
    registry_handler,
    NULL
};

int main() {
    parse_config();

    struct wl_display *display = wl_display_connect(NULL);
    if (!display) {
        fprintf(stderr, "Failed to connect to Wayland display\n");
        return -1;
    }

    struct wl_registry *registry = wl_display_get_registry(display);
    wl_registry_add_listener(registry, &registry_listener, NULL);
    wl_display_dispatch(display);
    wl_display_roundtrip(display);

    wl_display_disconnect(display);
    return 0;
}
