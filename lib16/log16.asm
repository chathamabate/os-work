; log_cell_16 : 
;   print out the 16-bit contents of a given address
;   in a easily readeable manner.
;
; params :
;   di - the address of the memory cell to log.
log_cell_16:
    push ax
    push cx

    mov ah, 0x0e
    print_char '['

    mov cx, di
    call print_hex_16   ; Print address.

    print_char ']'
    print_char ' '

    mov cx, [di]
    call print_hex_16   ; Print value at address.

    print_char ' '
    print_char '('
    call print_dec_16
    print_char ')'
    print_new_line

    pop cx
    pop ax

    ret


; log_cell_16_range : 
;   Print out a block of 16 bit memory cells.
;
; params :
;   di - The starting address of the range.
;   cx - The number of cells to print.
log_cell_16_range:
    cmp cx, 0
    jg XXX_log_cell_16_range_start

    ; We only need to run this function
    ; if cx is non zero.
    ret

XXX_log_cell_16_range_start:
    push di
    push cx

XXX_log_cell_16_range_loop:
    call log_cell_16

    add di, 0x2         ; move bx up by 2 bytes.
    dec cx
    jnz XXX_log_cell_16_range_loop

XXX_log_cell_16_range_end:
    pop cx
    pop di
    
    ret