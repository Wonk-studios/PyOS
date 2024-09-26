[BITS 16]
[org 0x7C00]

section .text
jmp start

; Stack dump routine
stack_dump:
    ; Save all registers
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp
    push sp

    ; Print the stack dump message
    mov si, error_dump_msg
    call print_string

    ; Dump the contents of all registers
    mov si, register_dump_msg
    call print_string

    ; Dump AX
    mov ax, 'AX'
    call print_register
    mov ax, [bp+16]
    call print_hex

    ; Dump BX
    mov ax, 'BX'
    call print_register
    mov ax, [bp+14]
    call print_hex

    ; Dump CX
    mov ax, 'CX'
    call print_register
    mov ax, [bp+12]
    call print_hex

    ; Dump DX
    mov ax, 'DX'
    call print_register
    mov ax, [bp+10]
    call print_hex

    ; Dump SI
    mov ax, 'SI'
    call print_register
    mov ax, [bp+8]
    call print_hex

    ; Dump DI
    mov ax, 'DI'
    call print_register
    mov ax, [bp+6]
    call print_hex

    ; Dump BP
    mov ax, 'BP'
    call print_register
    mov ax, [bp+4]
    call print_hex

    ; Dump SP
    mov ax, 'SP'
    call print_register
    mov ax, [bp+2]
    call print_hex
    ; Restore all registers
    pop sp
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop ip
    mov ax, 'IP'
    call print_register
    mov ax, [bp]
    call print_hex

    ; Restore all registers
    popa
    ret

; Print register name
print_register:
    mov di, VGA_TEXT_MODE_ADDRESS
    mov ah, VGA_RED_ON_BLACK

.next_char_reg:
    lodsb
    cmp al, 0
    je .done_reg
    stosw
    jmp .next_char_reg

.done_reg:
    ret

; Print hexadecimal value
print_hex:
    mov cx, 4
    mov bx, 0x10

.next_digit:
    rol ax, 4
    mov dl, al
    and dl, 0x0F
    cmp dl, 0x0A
    jl .digit_is_number
    add dl, 'A' - 0x0A
    jmp .print_digit

.digit_is_number:
    add dl, '0'

.print_digit:
    mov ah, VGA_WHITE_ON_BLACK
    stosw
    loop .next_digit
    ret

register_dump_msg db 'Register Dump:', 0

section .data
VGA_TEXT_MODE_ADDRESS equ 0xB8000
VGA_WHITE_ON_BLACK equ 0x0F00
VGA_RED_ON_BLACK equ 0x4F00

; Error handling messages
fatal_disk_read_error db 'FATAL VH001: FAILED TO READ DISK 0x7C00. HLT', 0
fatal_invalid_config_error db 'FATAL VH002: config.ini ILLEGAL FORMAT 0x7C00. HLT', 0
fatal_unknown_error db 'FATAL VH999: 0 0x0A000. HLT', 0
stack_dump_msg db 'STACK.dmp', 0

; Error handling routine
handle_error:
    ; Print the fatal error message
    call print_string
    
    ; Create a stack dump file
    call create_stack_dump
    
    ; Halt the CPU
    hlt

; Create a stack dump file
create_stack_dump:
    mov si, stack_dump_msg
    call print_string
    ret

boot_msg db 'ESC for terminal...', 0
fatal_invalid_boot_sector_error db 'FATAL VH007: ILLEGAL BOOT SECTOR AT 0x7C00. HLT', 0
fatal_corrupted_file_system_error db 'FATAL VH008: FILESYSTEM_CORRUPT  AT 0x7C00. HLT', 0
fatal_hardware_failure_error db 'FATAL VH009: HARDWARE_FAIL 0x7C00. HLT', 0
fatal_invalid_partition_table_error db 'FATAL VH010: ILLEGAL PARTITION TABLE AT 0x7C00. HLT', 0
fatal_boot_device_not_found_error db 'FATAL VH011: BOOT DEVICE NULL 0x7C00. HLT', 0
fatal_unsupported_filesystem_error db 'FATAL VH012: ILLEGAL FILESYSTEM 0x7C00. HLT', 0
fatal_bootloader_corruption_error db 'FATAL VH013: BOOTLOADER CORRUPTION 0x7C00. HLT', 0
fatal_insufficient_memory_error db 'FATAL VH014: INSUFFICIENT RANDOM ACCESS MEMORY 0x7C00. HLT', 0
fatal_cpu_exception_error db 'FATAL VH015: CENTRAL PROCESSING UNIT EXCEPTION 0x7C00. HLT', 0
fatal_io_error db 'FATAL VH016: INPUT/OUTPUT ERROR 0x7C00. HLT', 0
f12_message db 'Press F12 for terminal', 0
error_dump_msg db 'Error Dump:', 0
fatal_memory_allocation_error db 'FATAL VH003: CANNOT ALLOCATE MEMORY 0x7C00. HLT', 0
fatal_invalid_opcode_error db 'FATAL VH004: ILLEGAL OPCODE ERROR 0x7C00. HLT', 0
fatal_stack_overflow_error db 'FATAL VH005: STACK OVERFLOW! 0x7C00. HLT', 0
fatal_divide_by_zero_error db 'FATAL VH006: VAR/0 IS NOT A VALID EXPRESSION 0x7C00. HLT', 0

config_buffer times 512 db 0  ; Buffer to hold the config.ini content

section .text
global start
extern terminal_loop

start:
    ; Set up the stack
    xor ax, ax
    mov ss, ax
    mov sp, 0x7C00
    
    ; Clear interrupts
    cli
    
    ; Load the config.ini file from disk
    call load_config
    
    ; Parse the config.ini file
    call parse_config
    
    ; Check if show_message is true
    cmp byte [show_message], 1
    jne skip_message
    
    ; Print boot message
    mov si, boot_msg
    call print_string
    
skip_message:
    ; Halt the CPU
    hlt

; Load the config.ini file from disk
load_config:
    mov bx, config_buffer
    mov dh, 0
disk_read_error_handle:
    ; Handle disk read error
    mov si, fatal_disk_read_error
    call handle_error

invalid_config_error:
unknown_error:
    ; Handle unknown error
    mov si, fatal_unknown_error
    call handle_error
    ret

memory_allocation_error:
    ; Handle memory allocation error
    mov si, fatal_memory_allocation_error
    call handle_error
    ret

invalid_opcode_error:
    ; Handle invalid opcode error
    mov si, fatal_invalid_opcode_error
    call handle_error
    ret

stack_overflow_error:
    ; Handle stack overflow error
    mov si, fatal_stack_overflow_error
    call handle_error
    ret

divide_by_zero_error:
    ; Handle divide by zero error
    mov si, fatal_divide_by_zero_error
    call handle_error
    ret ah, 0x02
    mov al, 1
    int 0x13
    jc disk_read_error
    ret

disk_read_error_simple:
    ; Handle disk read error (simplified example)
    hlt

; Parse the config.ini file
parse_config:
    mov si, config_buffer
    call find_show_message
    ret

; Find the show_message setting in the config.ini file
find_show_message:
    mov di, show_message_str
    call find_string
    cmp byte [si], '='
    jne not_found
    inc si
    cmp byte [si], 't'
    jne not_true
    mov byte [show_message], 1
    ret

not_true:
    mov byte [show_message], 0
    ret

not_found:
    mov byte [show_message], 0
    ret

; Find a string in the config.ini file
find_string:
    push si
    push di

next_char:
    lodsb
    cmp al, 0
    je not_found
    cmp al, [di]
    jne next_char
    inc di
    cmp byte [di], 0
    je found
    jmp next_char

found:
    pop di
    pop si
    ret

show_message_str db 'show_message', 0
show_message db 0

; Print string
print_string:
    mov di, VGA_TEXT_MODE_ADDRESS
    mov ah, VGA_WHITE_ON_BLACK

.next_char:
    lodsb
    cmp al, 0
    je .done
    stosw
    jmp .next_char

.done:
    ret

times 510-($-$$) db 0   ; Fill boot sector up to 510 bytes
dw 0xAA55               ; Boot sector signature
