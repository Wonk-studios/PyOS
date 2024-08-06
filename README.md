# PyOS

PyOs.

PyOS is a rudimentary python interpreter operating system I started in 2024 as a hobby project and wrote by myself. It allows you to paint off the canvas, and take your projects next level.

How to use:

>[!IMPORTANT]
>The operating system has not been fully written. Do not download the operating system until it has been written.
>THIS CODE IS WORK IN PROGRESS!

DO NOT REMOVE THE LICENSE!

Error guide:

# Error Codes for PyOS

## Bootloader Errors

### Disk Read Error
**Code**: VH01  
**Message**: Error VH01: DISK READ ERROR. STOP.  
**Description**: This error indicates that the bootloader encountered an issue while reading from the disk. Check the disk hardware and ensure the disk is correctly formatted.

### Invalid Kernel Error
**Code**: VH52  
**Message**: Error VH52: INVALID KERNEL DETECTED. CANNOT LOAD. STOP.  
**Description**: This error occurs when the bootloader detects that the kernel is not valid. Verify that the kernel image is correctly formatted and not corrupted.

## Kernel Errors

### Kernel Initialization Error
**Code**: VH21  
**Message**: Error VH21: KERNEL INITIALIZATION ERROR. STOP.  
**Description**: Occurs if the kernel fails to initialize properly. Check initialization routines and ensure all components are correctly set up.

### Memory Allocation Error
**Code**: VH22  
**Message**: Error VH22: MEMORY ALLOCATION ERROR. STOP.  
**Description**: Indicates an issue with memory allocation. Verify memory management routines and ensure memory is properly allocated and accessed.

## Python Interpreter Errors

### Interpreter Initialization Error
**Code**: VH32  
**Message**: Error VH32: Python Interpreter Initialization Error.  
**Description**: Indicates that the Python interpreter failed to initialize. Check the interpreter setup and ensure all dependencies are correctly configured.

### Script Execution Error
**Code**: VH33  
**Message**: Error VH33: Error executing Python script.  
**Description**: Occurs if there is an issue executing a Python script. Verify script validity and file access.
