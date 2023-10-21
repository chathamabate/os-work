

org 0x7C00

;; Starting in 16 bit mode boys.
;; Looks like this is working...
bits 16

%define ENDL 0x0D, 0x0A

start:
    jmp main

;; Print a string to the terminal.
;; Params :
;;  - ds:si - The address of the string to be
;;            printed.
puts:
    push si
    push ax

;; Basically we loop until we get to the NULL_TERMINATOR.

.loop:
    ;; Also works!
    mov al, ds:[si]
    or al, al
    jz .loop_exit

    ;; print out ax.
    
    mov ah, 0x0E
    mov bh, 0
    int 0x10

    inc si
    
    jmp .loop

.loop_exit:
    pop ax
    pop si

    ret

main:
    mov ax, 0
    mov ds, ax ;; Set up data segments.
    mov es, ax

    ;; Set up the stack.
    mov ss, ax
    mov sp, 0x7C00

    mov si, hello_msg
    call puts

    hlt

.halt:
    jmp .halt

hello_msg: db "Hello World!", ENDL, 0

times 510-($-$$) db 0

;; Boot signature.
dw 0xAA55
