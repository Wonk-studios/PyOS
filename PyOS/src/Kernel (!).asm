[BITS 16]
[ORG 0x1000]

;THIS KERNEL IS OUT OF DATE AND NOT TO BE USED UNLESS THE PROTECTED MODE KERNEL FAILS!!!

start:
    ; Print kernel loaded message
    mov si, kernel_msg
    call print_string

    ; Jump to main C code
    call run_main

    ; Halt the CPU
    hlt
    jmp $

print_string:
    mov ah, 0x0E
.repeat:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .repeat
.done:
    ret

run_main:
    ; Jump to the C code entry point
    call main
    ; Check if main returned an error
    test ax, ax
    jnz kernel_error
    ret

kernel_error:
    mov si, kernel_error_msg
    call print_string
    hlt

unknown_error:
    mov si, unknown_error_msg
    call print_string
    hlt

kernel_msg db '...', 0
kernel_error_msg db 'ERROR VH05 UNKNOWN KERNEL ERROR. MANUAL REBOOT REQUIRED. STOP.', 0
kernel_initialization_error_msg db 'Error VH21: KERNEL INITIALIZATION ERROR. MANUAL REBOOT REQUIRED. STOP.', 0
memory_allocation_error_msg db 'Error VH22: MEMORY ALLOCATION ERROR. MANUAL REBOOT REQUIRED. STOP.', 0
unknown_error_msg db 'ERROR STOP.', 0
