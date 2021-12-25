; Graphics code in 32 bit real mode.
[bits 32]

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0A

; print_string_32:
;   Print a string when the cpu is in 32 bit real mode.
; params:
;   esi - the source of the NULL terminated string.
print_string_32:
    push edi
    push esi
    push ax

    ; Printing goes to the VGA.
    mov edi, VIDEO_MEMORY
XXX_print_string_32_loop:
    ; First test for NULL char.
    mov al, [esi]
    cmp al, 0
    je XXX_print_string_32_end

    ; Otherwise, print the character.
    mov ah, WHITE_ON_BLACK
    mov [edi], ax

    inc esi
    add edi, 2  ; edi stores 2 bytes per character.

    jmp XXX_print_string_32_loop

XXX_print_string_32_end:
    pop ax
    pop esi
    pop edi

    ret

