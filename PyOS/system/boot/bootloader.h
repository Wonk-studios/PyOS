#ifndef BOOTLOADER_H
#define BOOTLOADER_H

bool load_kernel_x86(const char *kernel_path);
bool load_kernel_arm(const char *kernel_path);
void jump_to_kernel_x86();
void jump_to_kernel_arm();

#endif // BOOTLOADER_H