section .text
global _start

extern init_logger, check_memory, check_cpu

_start:
    call init_logger

main_loop:
    call check_memory
    call check_cpu
    ; Your main loop code here
    jmp main_loop