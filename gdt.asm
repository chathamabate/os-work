; The Global Descriptor Table!

gdt_start:

gdt_null:   ; The Null Segment.
    dd 0x00000000 ; 8 empty bytes.
    dd 0x00000000

gdt_code:
    dw 0xFFFF       ; Segment limit bits 0 - 15
    dw 0x0000       ; base address bits 0 - 15
    db 0x00         ; base address bits 16 - 23
    db 10011010b    ; P DPL S Type
    db 11001111b    ; G D/B L AVL Limit bits 16 - 19
    db 0x00         ; base address bits 24 - 31

gdt_data:
    dw 0xFFFF       ; Segment limit bits 0 - 15
    dw 0x0000       ; base address bits 0 - 15
    db 0x00         ; base address bits 16 - 23
    db 10010010b    ; P DPL S Type
    db 11001111b    ; G D/B L AVL Limit bits 16 - 19
    db 0x00         ; base address bits 24 - 31

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
