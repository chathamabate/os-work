%define NEW_LINE 0x0d, 0x0a

; print_char:
;   print a single character.
;
; params :
;   %1 - the character to print.
%macro print_char 1
    mov al, %1
    int 0x10
%endmacro


; print_new_line:
;   print a new line. 
;   i.e. skip down a line and return
;   to the beginning of the new line.
%macro print_new_line 0
    print_char 0x0d
    print_char 0x0a
%endmacro


; print_string :
;   print a NULL terminated string.
;
; params : 
;   si - The address of the NULL terminated 
;   string to print.
print_string:
    push ax
    push si
    
    mov ah, 0x0e

XXX_print_string_loop:
    mov al, [si]
    cmp al, 0

    ; End loop when \0 is found.
    je XXX_print_string_end

    ; otherwise, continue loop
    int 0x10
    inc si
    jmp XXX_print_string_loop

XXX_print_string_end:
    pop si
    pop ax
    ret


; print_hex_16:
;   Print a 16 bit value in hex.
;
; params:
;   cx - The value to print.
print_hex_16:
    push si
    push di

    ; Allocate space for the string on the stack.
    sub sp, (5 * 2)

    mov di, sp
    call to_hex_str_16

    mov si, di
    call print_string

    ; Free allocated space. (10 bytes in all)
    add sp, (5 * 2)

    pop di
    pop si

    ret


; print_dec_16:
;   Print out a decimal value.
;
; params:
;   cx - The value.
print_dec_16:
    push si
    push di
    
    sub sp, (6 * 2)

    mov di, sp
    call to_dec_str_16

    mov si, di
    call print_string

    add sp, (6 * 2)

    pop di
    pop si
    
    ret    


; to_hex_str_16 :
;   Transform a 16 bit value into a NULL terminated hexidecimal 
;   string.
;
; params :
;   di - The address of where to store the resulting string.
;   cx - The value itself.
to_hex_str_16:
    ; Save state.
    push ax
    push bx

    ; 4 rotations are required.
    ; bx will also be used as an index here.
    mov bx, 4

    ; Writing back to front... start with NULL terminator.
    mov al, 0
    mov [di + bx], al

XXX_to_hex_str_16_loop:
    dec bx

    mov al, cl
    and al, 0x0F ; Clear top 4 bits.

    cmp al, 10
    jge XXX_to_hex_str_16_letter

XXX_to_hex_str_16_digit:
    add al, '0'
    jmp XXX_to_hex_str_16_loop_continue

XXX_to_hex_str_16_letter:
    add al, 'A' - 10

XXX_to_hex_str_16_loop_continue:
    
    mov [di + bx], al

    ror cx, 4
    cmp bx, 0
    jg XXX_to_hex_str_16_loop

    ; Restore.
    pop bx
    pop ax

    ret


; to_dec_str_16:
;   Transform a 16 bit value into a string of its decimal representation.
;
; params:
;   di - The destination to store the string.
;   cx - The value.
to_dec_str_16:
    ; Save.
    push_grs
    push di

    mov ax, cx
    mov cx, 10

    mov bx, 5
XXX_to_dec_str_16_loop:
    ; Prepare for division.
    mov dx, 0x0000
    div cx

    push dx ; Push remainder onto the stack.

    dec bx
    jnz XXX_to_dec_str_16_loop

    mov bx, 5
XXX_to_dec_str_16_zero_loop:
    pop ax
    cmp ax, 0
    jnz XXX_to_dec_str_16_str_loop_skip

    dec bx
    cmp bx, 1 ; Make sure there is at least one digit on the stack.
    jg XXX_to_dec_str_16_zero_loop

XXX_to_dec_str_16_str_loop:
    pop ax
XXX_to_dec_str_16_str_loop_skip:
    add al, '0'
    mov [di], al
    inc di  ; Increment method a little more intuitive.
    
    dec bx
    jnz XXX_to_dec_str_16_str_loop

    ; Write the NULL Terminator.
    mov al, 0x00
    mov [di], al

    ; Restore.
    pop di
    pop_grs

    ret