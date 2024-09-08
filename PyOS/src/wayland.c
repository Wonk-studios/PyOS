// src/wayland.c
#include <wayland-client.h>
#include <stdio.h>

static void registry_handler(void *data, struct wl_registry *registry, uint32_t id, const char *interface, uint32_t version) {
    printf("Got a registry event for %s id %d\n", interface, id);
}

static const struct wl_registry_listener registry_listener = {
    registry_handler,
    NULL
};

int main() {
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