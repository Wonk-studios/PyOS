#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <string.h>
#include "acpi.h"

// ACPI RSDP structure
typedef struct {
    char signature[8];
    uint8_t checksum;
    char oem_id[6];
    uint8_t revision;
    uint32_t rsdt_address;
} __attribute__((packed)) RSDPDescriptor;

// ACPI RSDT structure
typedef struct {
    char signature[4];
    uint32_t length;
    uint8_t revision;
    uint8_t checksum;
    char oem_id[6];
    char oem_table_id[8];
    uint32_t oem_revision;
    uint32_t creator_id;
    uint32_t creator_revision;
    uint32_t entry[];
} __attribute__((packed)) RSDT;

// ACPI FADT structure
typedef struct {
    char signature[4];
    uint32_t length;
    uint8_t revision;
    uint8_t checksum;
    char oem_id[6];
    char oem_table_id[8];
    uint32_t oem_revision;
    uint32_t creator_id;
    uint32_t creator_revision;
    uint32_t firmware_ctrl;
    uint32_t dsdt;
    uint8_t reserved;
    uint8_t preferred_pm_profile;
    uint16_t sci_int;
    uint32_t smi_cmd;
    uint8_t acpi_enable;
    uint8_t acpi_disable;
    uint8_t s4bios_req;
    uint8_t pstate_cnt;
    uint32_t pm1a_evt_blk;
    uint32_t pm1b_evt_blk;
    uint32_t pm1a_cnt_blk;
    uint32_t pm1b_cnt_blk;
    uint32_t pm2_cnt_blk;
    uint32_t pm_tmr_blk;
    uint32_t gpe0_blk;
    uint32_t gpe1_blk;
    uint8_t pm1_evt_len;
    uint8_t pm1_cnt_len;
    uint8_t pm2_cnt_len;
    uint8_t pm_tmr_len;
    uint8_t gpe0_blk_len;
    uint8_t gpe1_blk_len;
    uint8_t gpe1_base;
    uint8_t cst_cnt;
    uint16_t p_lvl2_lat;
    uint16_t p_lvl3_lat;
    uint16_t flush_size;
    uint16_t flush_stride;
    uint8_t duty_offset;
    uint8_t duty_width;
    uint8_t day_alrm;
    uint8_t mon_alrm;
    uint8_t century;
    uint16_t iapc_boot_arch;
    uint8_t reserved2;
    uint32_t flags;
    uint8_t reset_reg[12];
    uint8_t reset_value;
    uint8_t reserved3[3];
    uint64_t x_firmware_ctrl;
    uint64_t x_dsdt;
    uint8_t x_pm1a_evt_blk[12];
    uint8_t x_pm1b_evt_blk[12];
    uint8_t x_pm1a_cnt_blk[12];
    uint8_t x_pm1b_cnt_blk[12];
    uint8_t x_pm2_cnt_blk[12];
    uint8_t x_pm_tmr_blk[12];
    uint8_t x_gpe0_blk[12];
    uint8_t x_gpe1_blk[12];
} __attribute__((packed)) FADT;

// Function to calculate checksum
static bool acpi_checksum(void *ptr, size_t size) {
    uint8_t sum = 0;
    for (size_t i = 0; i < size; i++) {
        sum += ((uint8_t *)ptr)[i];
    }
    return sum == 0;
}

// Function to find the RSDP
static RSDPDescriptor *find_rsdp() {
    for (uint64_t addr = 0x000E0000; addr < 0x00100000; addr += 16) {
        RSDPDescriptor *rsdp = (RSDPDescriptor *)addr;
        if (memcmp(rsdp->signature, "RSD PTR ", 8) == 0 && acpi_checksum(rsdp, sizeof(RSDPDescriptor))) {
            return rsdp;
        }
    }
    return NULL;
}

// Function to initialize ACPI
bool acpi_init() {
    RSDPDescriptor *rsdp = find_rsdp();
    if (!rsdp) {
        return false;
    }

    RSDT *rsdt = (RSDT *)(uintptr_t)rsdp->rsdt_address;
    if (memcmp(rsdt->signature, "RSDT", 4) != 0 || !acpi_checksum(rsdt, rsdt->length)) {
        return false;
    }

    for (size_t i = 0; i < (rsdt->length - sizeof(RSDT)) / 4; i++) {
        FADT *fadt = (FADT *)(uintptr_t)rsdt->entry[i];
        if (memcmp(fadt->signature, "FACP", 4) == 0 && acpi_checksum(fadt, fadt->length)) {
            // ACPI initialization successful
            return true;
        }
    }

    return false;
}

// Function to shut down the system
void acpi_shutdown() {
    RSDPDescriptor *rsdp = find_rsdp();
    if (!rsdp) {
        return;
    }

    RSDT *rsdt = (RSDT *)(uintptr_t)rsdp->rsdt_address;
    for (size_t i = 0; i < (rsdt->length - sizeof(RSDT)) / 4; i++) {
        FADT *fadt = (FADT *)(uintptr_t)rsdt->entry[i];
        if (memcmp(fadt->signature, "FACP", 4) == 0 && acpi_checksum(fadt, fadt->length)) {
            outw(fadt->pm1a_cnt_blk, 0x2000);
            if (fadt->pm1b_cnt_blk) {
                outw(fadt->pm1b_cnt_blk, 0x2000);
            }
            return;
        }
    }
}

// Function to put the system to sleep
void acpi_sleep() {
    RSDPDescriptor *rsdp = find_rsdp();
    if (!rsdp) {
        return;
    }

    RSDT *rsdt = (RSDT *)(uintptr_t)rsdp->rsdt_address;
    for (size_t i = 0; i < (rsdt->length - sizeof(RSDT)) / 4; i++) {
        FADT *fadt = (FADT *)(uintptr_t)rsdt->entry[i];
        if (memcmp(fadt->signature, "FACP", 4) == 0 && acpi_checksum(fadt, fadt->length)) {
            outw(fadt->pm1a_cnt_blk, 0x2000 | (1 << 13));
            if (fadt->pm1b_cnt_blk) {
                outw(fadt->pm1b_cnt_blk, 0x2000 | (1 << 13));
            }
            return;
        }
    }
}

// Function to restart the system
void acpi_restart() {
    RSDPDescriptor *rsdp = find_rsdp();
    if (!rsdp) {
        return;
    }

    RSDT *rsdt = (RSDT *)(uintptr_t)rsdp->rsdt_address;
    for (size_t i = 0; i < (rsdt->length - sizeof(RSDT)) / 4; i++) {
        FADT *fadt = (FADT *)(uintptr_t)rsdt->entry[i];
        if (memcmp(fadt->signature, "FACP", 4) == 0 && acpi_checksum(fadt, fadt->length)) {
            outb(fadt->reset_reg[0], fadt->reset_value);
            return;
        }
    }
}