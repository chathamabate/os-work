[org 0x7c00] ; Start of the boot sector!
jmp set_up

%include "util.asm"
%include "str16.asm"
%include "disk.asm"
%include "log16.asm"

set_up:
    ; Stack set up.
    mov bp, 0x9000 
    mov sp, bp

main:
    mov dh, 5
    mov dl, 0

    mov bx, 0xa000
    mov es, bx

    mov bx, 0x0000

    call disk_load

    jmp $   ; Loop forever!


XXX__PADDING__XXX:
    ; Padding and magic BIOS number.
    times 510-($-$$) db 0 
    dw 0xaa55

