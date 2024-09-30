# PyOS

PyOs.

PyOS is a rudimentary python interpreter operating system I started in 2024 as a hobby project and wrote by myself. It allows you to paint off the canvas, and take your projects next level.

>[!IMPORTANT]
>The operating system has not been fully written. Do not download the operating system until it has been written.
>THIS PROJECT IS WORK IN PROGRESS!

## 1. How to use:

1. fork the repository into your own.

2. Open "/workspaces/PyOS/PyOS/interpret/script/script.py"

3. Write your python script in that file

4. Make.
	For Linux/Unix users:
	- Run build.bash
	For Windows users:
	- Run build.bat

### 1A. For Python Modules:
The stock interpreter does not support any python modules. In order to be able to interpret Python modules you must install the corresponding plugin from the website or organization and install them into "/workspaces/PyOS/PyOS/interpret/plugins/".

>[!NOTE]
>You will need to know how to write makefile code to install plugins in order to have the plugins be compiled!

### 1B. Alternative method for modules
- Each official PyOS plugin comes with a "compiled" folder, and instructions are included in the readme under compiled folder.

DO NOT REMOVE THE LICENSE!

### 1C. System requirements:
- Memory: Minimum 200 mb
- Disk storage: Minimum 20 GB free disk space
- Network: Broadband internet connection
- Software: Python 2.7 minimum, 3.x reccomended

For nerds:
- Firmware: must boot to 0x7C00 for boot manager
- UEFI support is optional but recommended
- Minimum 2 GHz dual-core processor
- At least 1 GB of swap space
- Support for virtualization (VT-x or AMD-V)
- Network interface card (NIC) with PXE boot capability
- Serial console redirection support

## 2. Error guide

### 2A. Bootloader errors:
### ARM bootloader:

#### FATAL STOP ERROR: FAILED TO READ DISK 0x7C00. HLT
**Error Message:** FATAL STOP ERROR: FAILED TO READ DISK 0x7C00. HLT

**Description:** This error occurs when the bootloader fails to read the disk at the specified address (0x7C00).

**Possible Causes:**
- Disk is not properly connected.
- Disk is corrupted or unreadable.
- Disk read function is not implemented correctly.

**Troubleshooting Steps:**
1. Verify the disk connection.
2. Check the disk for corruption.
3. Ensure the disk read function is correctly implemented.

#### FATAL VH002: CONFIG PARSE ERROR 0x7C10. HLT
**Error Message:** FATAL VH002: CONFIG PARSE ERROR 0x7C10. HLT

**Description:** This error occurs when the bootloader fails to parse the `config.ini` file.

**Possible Causes:**
- `config.ini` file is missing or corrupted.
- Syntax error in the `config.ini` file.

**Troubleshooting Steps:**
1. Verify the presence and integrity of the `config.ini` file.
2. Check the `config.ini` file for syntax errors.

#### FATAL VH003: CONFIG VALUE ERROR 0x7C20. HLT
**Error Message:** FATAL VH003: CONFIG VALUE ERROR 0x7C20. HLT

**Description:** This error occurs when the bootloader encounters an invalid value in the `config.ini` file.

**Possible Causes:**
- Incorrect value in the `config.ini` file.
- Value does not match the expected format.

**Troubleshooting Steps:**
1. Verify the values in the `config.ini` file.
2. Ensure the values match the expected format.

#### FATAL VH004: STRING NOT FOUND 0x7C30. HLT
**Error Message:** FATAL VH004: STRING NOT FOUND 0x7C30. HLT

**Description:** This error occurs when the bootloader fails to find a required string in the `config.ini` file.

**Possible Causes:**
- Missing string in the `config.ini` file.
- Typographical error in the string.

**Troubleshooting Steps:**
1. Verify the presence of the required string in the `config.ini` file.
2. Check for typographical errors in the string.

#### FATAL VH005: STACK OVERFLOW 0x7C40. HLT
**Error Message:** FATAL VH005: STACK OVERFLOW 0x7C40. HLT

**Description:** This error occurs when the stack overflows due to excessive function calls or large data allocations.

**Possible Causes:**
- Infinite recursion.
- Large local variables or arrays.

**Troubleshooting Steps:**
1. Check for infinite recursion in the code.
2. Reduce the size of local variables or arrays.

#### FATAL VH006: INVALID OPCODE 0x7C50. HLT
**Error Message:** FATAL VH006: INVALID OPCODE 0x7C50. HLT

**Description:** This error occurs when the CPU encounters an invalid or undefined opcode.

**Possible Causes:**
- Corrupted code.
- Incorrectly compiled code.

**Troubleshooting Steps:**
1. Verify the integrity of the code.
2. Ensure the code is correctly compiled.

#### FATAL VH007: MEMORY ACCESS ERROR 0x7C60. HLT
**Error Message:** FATAL VH007: MEMORY ACCESS ERROR 0x7C60. HLT

**Description:** This error occurs when there is an illegal memory access.

**Possible Causes:**
- Accessing memory out of bounds.
- Dereferencing null or invalid pointers.

**Troubleshooting Steps:**
1. Check for out-of-bounds memory access.
2. Ensure pointers are valid before dereferencing.

#### FATAL VH008: DIVIDE BY ZERO 0x7C70. HLT
**Error Message:** FATAL VH008: DIVIDE BY ZERO 0x7C70. HLT

**Description:** This error occurs when a division by zero is attempted.

**Possible Causes:**
- Division operation with zero as the divisor.

**Troubleshooting Steps:**
1. Ensure the divisor is not zero before performing division.

#### FATAL VH009: GENERAL PROTECTION FAULT 0x7C80. HLT
**Error Message:** FATAL VH009: GENERAL PROTECTION FAULT 0x7C80. HLT

**Description:** This error occurs when a general protection fault is detected.

**Possible Causes:**
- Invalid memory access.
- Privilege level violation.

**Troubleshooting Steps:**
1. Check for invalid memory access.
2. Ensure proper privilege levels for operations.

#### FATAL VH010: PAGE FAULT 0x7C90. HLT
**Error Message:** FATAL VH010: PAGE FAULT 0x7C90. HLT

**Description:** This error occurs when a page fault is detected.

**Possible Causes:**
- Accessing a non-present page.
- Page table corruption.

**Troubleshooting Steps:**
1. Verify page table integrity.
2. Ensure pages are present before accessing.

#### FATAL VH011: DOUBLE FAULT 0x7CA0. HLT
**Error Message:** FATAL VH011: DOUBLE FAULT 0x7CA0. HLT

**Description:** This error occurs when a double fault is detected.

**Possible Causes:**
- Nested exceptions.
- Stack overflow during exception handling.

**Troubleshooting Steps:**
1. Check for nested exceptions.
2. Ensure sufficient stack space for exception handling.

#### FATAL VH012: SEGMENT NOT PRESENT 0x7CB0. HLT
**Error Message:** FATAL VH012: SEGMENT NOT PRESENT 0x7CB0. HLT

**Description:** This error occurs when a segment is not present.

**Possible Causes:**
- Accessing a non-present segment.
- Segment descriptor corruption.

**Troubleshooting Steps:**
1. Verify segment descriptor integrity.
2. Ensure segments are present before accessing.

#### FATAL VH013: STACK SEGMENT FAULT 0x7CC0. HLT
**Error Message:** FATAL VH013: STACK SEGMENT FAULT 0x7CC0. HLT

**Description:** This error occurs when a stack segment fault is detected.

**Possible Causes:**
- Stack overflow.
- Invalid stack segment access.

**Troubleshooting Steps:**
1. Check for stack overflow.
2. Ensure valid stack segment access.

#### FATAL VH014: MACHINE CHECK 0x7CD0. HLT
**Error Message:** FATAL VH014: MACHINE CHECK 0x7CD0. HLT

**Description:** This error occurs when a machine check is detected.

**Possible Causes:**
- Hardware failure.
- Critical system error.

**Troubleshooting Steps:**
1. Check for hardware issues.
2. Ensure system stability.

#### FATAL VH015: ALIGNMENT CHECK 0x7CE0. HLT
**Error Message:** FATAL VH015: ALIGNMENT CHECK 0x7CE0. HLT

**Description:** This error occurs when an alignment check fails.

**Possible Causes:**
- Misaligned memory access.
- Data structure alignment issues.

**Troubleshooting Steps:**
1. Ensure proper memory alignment.
2. Verify data structure alignment.

#### FATAL VH016: SIMD FLOATING POINT EXCEPTION 0x7CF0. HLT
**Error Message:** FATAL VH016: SIMD FLOATING POINT EXCEPTION 0x7CF0. HLT

**Description:** This error occurs when a SIMD floating point exception is detected.

**Possible Causes:**
- Invalid SIMD operation.
- Floating point arithmetic error.

**Troubleshooting Steps:**
1. Verify SIMD operations.
2. Check for floating point arithmetic errors.

#### FATAL VH017: VIRTUALIZATION EXCEPTION 0x7D00. HLT
**Error Message:** FATAL VH017: VIRTUALIZATION EXCEPTION 0x7D00. HLT

**Description:** This error occurs when a virtualization exception is detected.

**Possible Causes:**
- Invalid virtualization operation.
- Hypervisor issues.

**Troubleshooting Steps:**
1. Verify virtualization operations.
2. Check for hypervisor issues.

#### FATAL VH018: CONTROL PROTECTION EXCEPTION 0x7D10. HLT
**Error Message:** FATAL VH018: CONTROL PROTECTION EXCEPTION 0x7D10. HLT

**Description:** This error occurs when a control protection exception is detected.

**Possible Causes:**
- Control flow integrity violation.
- Invalid control transfer.

**Troubleshooting Steps:**
1. Ensure control flow integrity.
2. Verify control transfers.

#### FATAL VH019: HYPERVISOR INJECTION EXCEPTION 0x7D20. HLT
**Error Message:** FATAL VH019: HYPERVISOR INJECTION EXCEPTION 0x7D20. HLT

**Description:** This error occurs when a hypervisor injection exception is detected.

**Possible Causes:**
- Invalid hypervisor injection.
- Hypervisor configuration issues.

**Troubleshooting Steps:**
1. Verify hypervisor injections.
2. Check hypervisor configuration.

#### FATAL VH020: VMM COMMUNICATION EXCEPTION 0x7D30. HLT
**Error Message:** FATAL VH020: VMM COMMUNICATION EXCEPTION 0x7D30. HLT

**Description:** This error occurs when a VMM communication exception is detected.

**Possible Causes:**
- Invalid VMM communication.
- VMM configuration issues.

**Troubleshooting Steps:**
1. Verify VMM communications.
2. Check VMM configuration.

#### FATAL VH021: SECURITY EXCEPTION 0x7D40. HLT
**Error Message:** FATAL VH021: SECURITY EXCEPTION 0x7D40. HLT

**Description:** This error occurs when a security exception is detected.

**Possible Causes:**
- Security policy violation.
- Unauthorized access attempt.

**Troubleshooting Steps:**
1. Ensure compliance with security policies.
2. Verify access permissions.

#### FATAL VH022: RESERVED EXCEPTION 0x7D50. HLT
**Error Message:** FATAL VH022: RESERVED EXCEPTION 0x7D50. HLT

**Description:** This error occurs when a reserved exception is detected.

**Possible Causes:**
- Reserved exception code triggered.
- System configuration issues.

**Troubleshooting Steps:**
1. Verify system configuration.
2. Check for reserved exception triggers.

#### FATAL VH023: UNKNOWN EXCEPTION 0x7D60. HLT
**Error Message:** FATAL VH023: UNKNOWN EXCEPTION 0x7D60. HLT

**Description:** This error occurs when an unknown exception is detected.

**Possible Causes:**
- Unhandled exception.
- System instability.

**Troubleshooting Steps:**
1. Check for unhandled exceptions.
2. Ensure system stability.


### x86 bootloader

#### FATAL VH001: FAILED TO READ DISK 0x7C00. HLT
**Error Message:** FATAL VH001: FAILED TO READ DISK 0x7C00. HLT

**Description:** This error occurs when the bootloader fails to read the disk at the specified address (0x7C00).

**Possible Causes:**
- Disk is not properly connected.
- Disk is corrupted or unreadable.
- Disk read function is not implemented correctly.

**Troubleshooting Steps:**
1. Verify the disk connection.
2. Check the disk for corruption.
3. Ensure the disk read function is correctly implemented.

#### FATAL VH002: config.ini ILLEGAL FORMAT 0x7C00. HLT
**Error Message:** FATAL VH002: config.ini ILLEGAL FORMAT 0x7C00. HLT

**Description:** This error occurs when the bootloader fails to parse the `config.ini` file due to an illegal format.

**Possible Causes:**
- `config.ini` file is missing or corrupted.
- Syntax error in the `config.ini` file.

**Troubleshooting Steps:**
1. Verify the presence and integrity of the `config.ini` file.
2. Check the `config.ini` file for syntax errors.

#### FATAL VH003: CANNOT ALLOCATE MEMORY 0x7C00. HLT
**Error Message:** FATAL VH003: CANNOT ALLOCATE MEMORY 0x7C00. HLT

**Description:** This error occurs when the bootloader fails to allocate the necessary memory.

**Possible Causes:**
- Insufficient memory available.
- Memory allocation function is not implemented correctly.

**Troubleshooting Steps:**
1. Ensure sufficient memory is available.
2. Verify the memory allocation function.

#### FATAL VH004: ILLEGAL OPCODE ERROR 0x7C00. HLT
**Error Message:** FATAL VH004: ILLEGAL OPCODE ERROR 0x7C00. HLT

**Description:** This error occurs when the CPU encounters an illegal or undefined opcode.

**Possible Causes:**
- Corrupted code.
- Incorrectly compiled code.

**Troubleshooting Steps:**
1. Verify the integrity of the code.
2. Ensure the code is correctly compiled.

#### FATAL VH005: STACK OVERFLOW! 0x7C00. HLT
**Error Message:** FATAL VH005: STACK OVERFLOW! 0x7C00. HLT

**Description:** This error occurs when the stack overflows due to excessive function calls or large data allocations.

**Possible Causes:**
- Infinite recursion.
- Large local variables or arrays.

**Troubleshooting Steps:**
1. Check for infinite recursion in the code.
2. Reduce the size of local variables or arrays.

#### FATAL VH006: VAR/0 IS NOT A VALID EXPRESSION 0x7C00. HLT
**Error Message:** FATAL VH006: VAR/0 IS NOT A VALID EXPRESSION 0x7C00. HLT

**Description:** This error occurs when a division by zero is attempted.

**Possible Causes:**
- Division operation with zero as the divisor.

**Troubleshooting Steps:**
1. Ensure the divisor is not zero before performing division.

#### FATAL VH007: ILLEGAL BOOT SECTOR AT 0x7C00. HLT
**Error Message:** FATAL VH007: ILLEGAL BOOT SECTOR AT 0x7C00. HLT

**Description:** This error occurs when the bootloader detects an illegal boot sector.

**Possible Causes:**
- Corrupted boot sector.
- Invalid boot sector format.

**Troubleshooting Steps:**
1. Verify the integrity of the boot sector.
2. Ensure the boot sector format is valid.

#### FATAL VH008: FILESYSTEM_CORRUPT AT 0x7C00. HLT
**Error Message:** FATAL VH008: FILESYSTEM_CORRUPT AT 0x7C00. HLT

**Description:** This error occurs when the bootloader detects a corrupted filesystem.

**Possible Causes:**
- Filesystem corruption.
- Disk errors.

**Troubleshooting Steps:**
1. Check the filesystem for corruption.
2. Verify the disk for errors.

#### FATAL VH009: HARDWARE_FAIL 0x7C00. HLT
**Error Message:** FATAL VH009: HARDWARE_FAIL 0x7C00. HLT

**Description:** This error occurs when the bootloader detects a hardware failure.

**Possible Causes:**
- Faulty hardware components.
- Hardware malfunction.

**Troubleshooting Steps:**
1. Check the hardware components.
2. Ensure the hardware is functioning correctly.

#### FATAL VH010: ILLEGAL PARTITION TABLE AT 0x7C00. HLT
**Error Message:** FATAL VH010: ILLEGAL PARTITION TABLE AT 0x7C00. HLT

**Description:** This error occurs when the bootloader detects an illegal partition table.

**Possible Causes:**
- Corrupted partition table.
- Invalid partition table format.

**Troubleshooting Steps:**
1. Verify the integrity of the partition table.
2. Ensure the partition table format is valid.

#### FATAL VH011: BOOT DEVICE NULL 0x7C00. HLT
**Error Message:** FATAL VH011: BOOT DEVICE NULL 0x7C00. HLT

**Description:** This error occurs when the bootloader cannot find the boot device.

**Possible Causes:**
- Boot device is not connected.
- Boot device is not recognized.

**Troubleshooting Steps:**
1. Verify the connection of the boot device.
2. Ensure the boot device is recognized by the system.

#### FATAL VH012: ILLEGAL FILESYSTEM 0x7C00. HLT
**Error Message:** FATAL VH012: ILLEGAL FILESYSTEM 0x7C00. HLT

**Description:** This error occurs when the bootloader detects an illegal filesystem.

**Possible Causes:**
- Unsupported filesystem.
- Filesystem corruption.

**Troubleshooting Steps:**
1. Ensure the filesystem is supported.
2. Check the filesystem for corruption.

#### FATAL VH013: BOOTLOADER CORRUPTION 0x7C00. HLT
**Error Message:** FATAL VH013: BOOTLOADER CORRUPTION 0x7C00. HLT

**Description:** This error occurs when the bootloader itself is corrupted.

**Possible Causes:**
- Bootloader code corruption.
- Disk errors affecting the bootloader.

**Troubleshooting Steps:**
1. Verify the integrity of the bootloader code.
2. Check the disk for errors.

#### FATAL VH014: INSUFFICIENT RANDOM ACCESS MEMORY 0x7C00. HLT
**Error Message:** FATAL VH014: INSUFFICIENT RANDOM ACCESS MEMORY 0x7C00. HLT

**Description:** This error occurs when there is insufficient RAM available for the bootloader.

**Possible Causes:**
- Not enough RAM installed.
- Memory allocation issues.

**Troubleshooting Steps:**
1. Ensure sufficient RAM is installed.
2. Verify memory allocation functions.

#### FATAL VH015: CENTRAL PROCESSING UNIT EXCEPTION 0x7C00. HLT
**Error Message:** FATAL VH015: CENTRAL PROCESSING UNIT EXCEPTION 0x7C00. HLT

**Description:** This error occurs when the CPU encounters an exception.

**Possible Causes:**
- Illegal instructions.
- Hardware faults.

**Troubleshooting Steps:**
1. Verify the code for illegal instructions.
2. Check for hardware faults.

#### FATAL VH016: INPUT/OUTPUT ERROR 0x7C00. HLT
**Error Message:** FATAL VH016: INPUT/OUTPUT ERROR 0x7C00. HLT

**Description:** This error occurs when there is an input/output error.

**Possible Causes:**
- Faulty I/O devices.
- I/O operation failures.

**Troubleshooting Steps:**
1. Check the I/O devices.
2. Verify the I/O operations.

### Kernel errors
