;; Utility Macros.

%macro push_grs 0
    push ax
    push bx
    push cx
    push dx
%endmacro

%macro pop_grs 0
    pop dx
    pop cx
    pop bx
    pop ax
%endmacro