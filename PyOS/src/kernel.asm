;So far there doesnt seem to be any issues in the code that NASM doesnt like...

[BITS 32]
[ORG 0x100000]  ; Kernel code starts at this address in protected mode

start:
    ; Initialize GDT and enter protected mode
    ; (Assuming GDT setup and protected mode initialization are complete)

    ; Initialize kernel
    call kernel_initialization

    ; Main kernel loop
main_loop:
    ; Kernel main code
    hlt  ; Halt CPU until next interrupt (temporary placeholder)

    jmp main_loop

kernel_initialization:
    ; Initialization code
    ; (This is where kernel initialization occurs)

    ; Check for initialization errors
    ; If an error occurs, jump to error handling
    ; (Example condition, replace with actual check)
    cmp eax, 0
    je kernel_initialization_error

    ; Proceed with memory allocation
    call memory_allocation

    ; Continue kernel initialization
    ret

memory_allocation:
    ; Memory allocation code
    ; (This is where memory is allocated)

    ; Check for allocation errors
    ; If an error occurs, jump to error handling
    ; (Example condition, replace with actual check)
    cmp eax, 0
    je memory_allocation_error

    ; Continue with kernel code
    ret

kernel_initialization_error:
    mov si, kernel_initialization_error_msg
    call print_string
    hlt

memory_allocation_error:
    mov si, memory_allocation_error_msg
    call print_string
    hlt

unknown_kernel_error:
    mov si, kernel_error_msg
    call print_string
    hlt

unknown_error:
    mov si, unknown_error_msg
    call print_string
    hlt

print_string:
    ; Function to print a null-terminated string pointed to by SI
    mov eax, 0x0E
.repeat:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .repeat
.done:
    ret

; Error messages
kernel_msg db '...', 0
kernel_error_msg db 'ERROR VH05 UNKNOWN KERNEL ERROR. MANUAL REBOOT REQUIRED. STOP.', 0
kernel_initialization_error_msg db 'Error VH21: KERNEL INITIALIZATION ERROR. MANUAL REBOOT REQUIRED. STOP.', 0
memory_allocation_error_msg db 'Error VH22: MEMORY ALLOCATION ERROR. MANUAL REBOOT REQUIRED. STOP.', 0
unknown_error_msg db 'ERROR STOP.', 0

; End of kernel
times 512 - ($ - $$) db 0  ; Fill remaining space to 512 bytes
