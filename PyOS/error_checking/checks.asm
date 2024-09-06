section .text
global check_memory, check_cpu

; Check memory status
check_memory:
    ; Placeholder for memory check logic
    ; If an error is detected, log it and halt the system
    ; Example: cmp [memory_status], 0
    ;          jne memory_error
    ret

memory_error:
    push dword memory_error_msg
    push dword memory_error_msg_len
    call log_error
    cli
    hlt

memory_error_msg db "Memory error detected!", 0xA, 0
memory_error_msg_len equ $ - memory_error_msg

; Check CPU status
check_cpu:
    ; Placeholder for CPU check logic
    ; If an error is detected, log it and halt the system
    ; Example: cmp [cpu_status], 0
    ;          jne cpu_error
    ret

cpu_error:
    push dword cpu_error_msg
    push dword cpu_error_msg_len
    call log_error
    cli
    hlt

cpu_error_msg db "CPU error detected!", 0xA, 0
cpu_error_msg_len equ $ - cpu_error_msg