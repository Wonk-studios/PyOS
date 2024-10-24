#ifndef ACPI_H
#define ACPI_H

#include <stdbool.h>

bool acpi_init();
void acpi_shutdown();
void acpi_sleep();
void acpi_restart();

#endif // ACPI_H