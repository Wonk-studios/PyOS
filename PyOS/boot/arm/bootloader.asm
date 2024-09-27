.section .text
.global _start

_start:
	b reset

reset:
	ldr sp, =0x8000          @ Set up stack pointer
	bl load_config           @ Load the config.ini file from disk
	bl parse_config          @ Parse the config.ini file

	ldr r0, =show_message
	ldrb r0, [r0]
	cmp r0, #1
	bne skip_message

	ldr r0, =boot_msg
	bl print_string

skip_message:
	b .

load_config:
	ldr r0, =config_buffer
	bl read_disk
	bx lr

read_disk:
	@ Assuming read_disk is a function that reads from disk into r0 buffer
	@ This is a placeholder for actual disk read implementation
	@ Replace with actual disk read code
	mov r1, #512  @ Number of bytes to read
	bl disk_read  @ Call disk read function
	cmp r0, #0    @ Check if read was successful
	bne disk_read_error_handle
	bx lr

disk_read_error_handle:
	ldr r0, =fatal_disk_read_error
	bl handle_error
	bx lr

handle_error:
	bl dump_registers
	bl print_string
	b .

parse_config:
	ldr r0, =config_buffer
	bl find_show_message
	bx lr

find_show_message:
	ldr r1, =show_message_str
	bl find_string
	ldrb r0, [r0]
	cmp r0, #'='
	bne config_parse_error
	add r0, r0, #1
	ldrb r0, [r0]
	cmp r0, #'t'
	bne config_value_error
	mov r0, #1
	strb r0, [r1]
	bx lr

config_parse_error:
	ldr r0, =fatal_config_parse_error
	bl handle_error
	bx lr

config_value_error:
	ldr r0, =fatal_config_value_error
	bl handle_error
	bx lr

find_string:
	push {r0, r1, r2, r3}

next_char:
	ldrb r2, [r0], #1
	cmp r2, #0
	beq not_found
	ldrb r3, [r1], #1
	cmp r2, r3
	bne next_char
	add r1, r1, #1
	ldrb r3, [r1]
	cmp r3, #0
	beq found
	sub r1, r1, #1
	b next_char

found:
	sub r0, r0, r1
	pop {r0, r1, r2, r3}
	bx lr

not_found:
	ldr r0, =fatal_string_not_found
	bl handle_error
	bx lr

dump_registers:
	@ Dump all registers to a known memory location
	ldr r1, =register_dump
	stm r1!, {r0-r12, lr}
	bx lr

show_message_str:
	.asciz "show_message"
show_message:
	.byte 0

print_string:
	ldr r1, =VGA_TEXT_MODE_ADDRESS
	mov r2, #VGA_WHITE_ON_BLACK

.next_char:
	ldrb r0, [r0], #1
	cmp r0, #0
	beq .done
	strh r0, [r1], #2
	b .next_char

.done:
	bx lr

.equ VGA_TEXT_MODE_ADDRESS, 0xB8000
.equ VGA_WHITE_ON_BLACK, 0x0F00

boot_msg:
	.asciz "ESC for terminal on ARM_ARCH... ..."

fatal_disk_read_error:
	.asciz "FATAL STOP ERROR: FAILED TO READ DISK 0x7C00. HLT"

fatal_config_parse_error:
	.asciz "FATAL VH002: CONFIG PARSE ERROR 0x7C10. HLT"

fatal_config_value_error:
	.asciz "FATAL VH003: CONFIG VALUE ERROR 0x7C20. HLT"

fatal_string_not_found:
	.asciz "FATAL VH004: STRING NOT FOUND 0x7C30. HLT"

fatal_stack_overflow:
	.asciz "FATAL VH005: STACK OVERFLOW 0x7C40. HLT"

fatal_invalid_opcode:
	.asciz "FATAL VH006: INVALID OPCODE 0x7C50. HLT"

fatal_memory_access_error:
	.asciz "FATAL VH007: MEMORY ACCESS ERROR 0x7C60. HLT"

fatal_divide_by_zero:
	.asciz "FATAL VH008: DIVIDE BY ZERO 0x7C70. HLT"

fatal_general_protection_fault:
	.asciz "FATAL VH009: GENERAL PROTECTION FAULT 0x7C80. HLT"

fatal_page_fault:
	.asciz "FATAL VH010: PAGE FAULT 0x7C90. HLT"

fatal_double_fault:
	.asciz "FATAL VH011: DOUBLE FAULT 0x7CA0. HLT"

fatal_segment_not_present:
	.asciz "FATAL VH012: SEGMENT NOT PRESENT 0x7CB0. HLT"

fatal_stack_segment_fault:
	.asciz "FATAL VH013: STACK SEGMENT FAULT 0x7CC0. HLT"

fatal_machine_check:
	.asciz "FATAL VH014: MACHINE CHECK 0x7CD0. HLT"

fatal_alignment_check:
	.asciz "FATAL VH015: ALIGNMENT CHECK 0x7CE0. HLT"

fatal_simd_floating_point_exception:
	.asciz "FATAL VH016: SIMD FLOATING POINT EXCEPTION 0x7CF0. HLT"

fatal_virtualization_exception:
	.asciz "FATAL VH017: VIRTUALIZATION EXCEPTION 0x7D00. HLT"

fatal_control_protection_exception:
	.asciz "FATAL VH018: CONTROL PROTECTION EXCEPTION 0x7D10. HLT"

fatal_hypervisor_injection_exception:
	.asciz "FATAL VH019: HYPERVISOR INJECTION EXCEPTION 0x7D20. HLT"

fatal_vmm_communication_exception:
	.asciz "FATAL VH020: VMM COMMUNICATION EXCEPTION 0x7D30. HLT"

fatal_security_exception:
	.asciz "FATAL VH021: SECURITY EXCEPTION 0x7D40. HLT"

fatal_reserved_exception:
	.asciz "FATAL VH022: RESERVED EXCEPTION 0x7D50. HLT"

fatal_unknown_exception:
	.asciz "FATAL VH023: UNKNOWN EXCEPTION 0x7D60. HLT"

register_dump:
	.space 64  @ Space to store r0-r12 and lr

config_buffer:
	.space 512

.section .bss
.bss_space:
	.space 512
