[org 0x7c00] ; Start of the boot sector!
jmp set_up

%include "util.asm"

%include "str16.asm"

set_up:
    ; Stack set up.
    mov bp, 0x9000 
    mov sp, bp

main:
    push 0xAAAA
    push 0xBBBB
    push 0xCCCC

    mov di, sp
    mov cx, 2
    call log_cell_16_range

    ; call print_imm_hex_16

    jmp $   ; Loop forever!
    
    
source:
    dw 0x0000

dest:
    db 0, 0, 0, 0, 0, 1, 1



XXX__PADDING__XXX:
    ; Padding and magic BIOS number.
    times 510-($-$$) db 0 
    dw 0xaa55

