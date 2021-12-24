
; disk_load:
;   Load a disks contents into memory.
;
; params:
;   dh    - the number of sectors to load.
;   dl    - dl the drive to load from.
;   es:bx - the address to load to.
disk_load:
    push ax
    push cx
    push si

    push dx

    mov ah, 0x02
    mov ch, 0x00    ; 0 Cylinder.
    mov al, dh      ; Read dh sectors from the start.
    mov dh, 0x00    ; 0 Track.
    mov cl, 0x02    ; Sector 2 (1 indexed) After boot sector.

    int 0x13    ; Perform read.

    pop dx

    jc XXX_disk_load_error

    cmp dh, al
    jg XXX_disk_load_inconsistent

    jmp XXX_disk_load_end

XXX_disk_load_error:
    mov si, DDD_disk_load_error
    call print_string
    jmp XXX_disk_load_end

DDD_disk_load_error:
    db "Error Reading Disk!", NEW_LINE, 0

XXX_disk_load_inconsistent:
    mov si, DDD_disk_load_inconsistent
    call print_string
    jmp XXX_disk_load_end

DDD_disk_load_inconsistent:
    db "Did Not Copy All Sectors!", NEW_LINE, 0

XXX_disk_load_end:
    ; Restore here (Best we can)
    pop si
    pop cx
    pop ax
    
    ret