[org 0x7c00] ; Start of the boot sector!
KERNEL_OFFSET equ 0x1000
[bits 16]
    ; Jump to the start up routine.
    jmp start_up_rm

; Byte for storing the boot drive.
BOOT_DRIVE:
    db 0x00

%include "./lib16/util.asm"
%include "./lib16/str16.asm"
%include "./lib16/disk.asm"


start_up_rm:
    ; Store the boot drive.
    mov [BOOT_DRIVE], dl

    ; Set up stack.
    mov bp, 0x9000
    mov sp, bp

    mov si, DDD_start_up_rm_message
    call print_string    

    ; Load test :
    ; things seem to work despite error flag.
    ; mov bx, 0xA000
    ; mov dh, 6
    ; mov dl, [BOOT_DRIVE]
    ; call disk_load

    ; mov cx, [0xA000 + (512 * 5)]
    ; call print_hex_16

    ; jmp $
    
    jmp load_kernel

DDD_start_up_rm_message:
    db "OS starting...", NEW_LINE, 0

load_kernel:
    mov si, DDD_load_kernel_message
    call print_string

    mov bx, KERNEL_OFFSET
    mov dh, 15              ; Load 15 sectors.
                            ; The first sector is already loaded.
    mov dl, [BOOT_DRIVE]

    ; Load our kernel.
    call disk_load

    ; Switch to protected mode.
    jmp switch_to_pm


DDD_load_kernel_message:
    db "Loading kernel...", NEW_LINE, 0


switch_to_pm:
    mov si, DDD_switch_to_pm_message
    call print_string

    cli  ; Turn off interupts.
    lgdt [gdt_descriptor]

    ; Turn on 32 bit mode.
    mov eax, cr0
    or eax, 0x01
    mov cr0, eax

    jmp CODE_SEG:init_pm

DDD_switch_to_pm_message:
    db "Switching to 32-bit mode...", NEW_LINE, 0

[bits 32]
init_pm:
    mov ax, DATA_SEG ; Reset all out of date segment registers.
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Set up 32-bit stack.
    mov ebp, 0x90000
    mov esp, ebp

main_pm:
    ; mov esi, DDD_main_pm_message
    ; call print_string_32

    call KERNEL_OFFSET

    jmp $   ; Loop forever!

; DDD_main_pm_message:
;     db "Entering kernel..."

%include "gdt.asm"
%include "g32.asm"

XXX__PADDING__XXX:
    ; Padding and magic BIOS number.
    times 510-($-$$) db 0 
    dw 0xaa55
