

org 0x7C00

;; Starting in 16 bit mode boys.
;; Looks like this is working...
bits 16

%define ENDL 0x0D, 0x0A

;;
;; FAT 12 Header
;;
jmp short start
nop

bdb_oem:                    db "MSWIN4.1"           ; 8 bytes
bdb_bytes_per_sector:       dw 512
bdb_sectors_per_cluster:    db 1
bdb_reserved_sectors:       dw 1
bdb_fat_count:              db 2
bdb_dir_entries_count:      dw 0x00E0
bdb_total_sectors:          dw 2880                 ; 2880 * 512 = 1.44MB
bdb_media_descriptor_type:  db 0xF0                 ; F0 = 3.5" floppy disk
bdb_sectors_per_fat:        dw 9                    ; 9 sectors/fat
bdb_sectors_per_track:      dw 18
bdb_heads:                  dw 2
bdb_hidden_sectors:         dd 0
bdb_large_sector_count:     dd 0

; extended boot record
ebr_drive_number:           db 0                    ; 0x00 floppy, 0x80 hdd, useless
                            db 0                    ; reserved
ebr_signature:              db 0x29
ebr_volume_id:              db 0x12, 0x34, 0x56, 0x78   ; serial number, value doesn't matter
ebr_volume_label:           db "NANOBYTE OS"        ; 11 bytes, padded with spaces
ebr_system_id:              db "FAT12   "           ; 8 bytes


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

;; Convert LBA into CHS format
;; Params:
;;  - ax: LBA address.
;; Returns:
;;  - cx: [bits 0-5]: sector number.
;;  - cx: [bits 6-15]: Cylinder
;;  - dx: head
lba_to_chs:
    push ax
    push dx
    ;; spt = 18 and only 2 heads
    ;; 2880 sectors. (at 18 sectors per track)
    ;; 160 Tracks. (at 80 tracks per head)
    ;; 2 heads.
    ;;
    ;; 0 <= LBA < 2880 (I would expect)
    ;; sector   = (LBA % (sectors per track)) + 1
    ;; head     = (LBA / (sectors per track)) % heads
    ;; cylinder = (LBA / (sectors per track)) / heads

    xor dx, dx  ;; 0 out dx.
    div word [bdb_sectors_per_track]    ;; ax = LBA / spt 
                                        ;; dx = LBA % spt
    inc dx
    mov cx, dx  ;; Set Sector in cx (this will be <18 5 bits is enough)

    xor dx, dx  ;; clear dx.
    div word [bdb_heads]    ;; ax = (LBA / spt) / heads (cylinder)
                            ;; dx = (LBA / spt) % heads (head)

    mov dh, dl  ;; I guess head must be in dh?

    ;; Now must add cylinder index into cx. (Really ch)
    mov ch, al
    shl ah, 6
    or cl, ah

    pop dx 
    pop ax

    ret 

;; Copied directly from github...
;; Read sectors from the disk into memory.
;; Params:
;;  - ax : LBA Address.
;;  - cl : number of sectors to read (up to 128)
;;  - dl : drive number
;;  - es:bx : memory address to store data.
disk_read:

    push ax                             ; save registers we will modify
    push bx
    push cx
    push dx
    push di

    push cx                             ; temporarily save CL (number of sectors to read)
    call lba_to_chs                     ; compute CHS
    pop ax                              ; AL = number of sectors to read
    
    mov ah, 0x02
    mov di, 3                           ; retry count

.retry:
    pusha                               ; save all registers, we don't know what bios modifies
    stc                                 ; set carry flag, some BIOS'es don't set it
    int 0x13                            ; carry flag cleared = success
    jnc .done                           ; jump if carry not set

    ; read failed
    popa
    call disk_reset

    dec di
    test di, di
    jnz .retry

.fail:
    ; all attempts are exhausted
    jmp floppy_error

.done:
    popa

    pop di
    pop dx
    pop cx
    pop bx
    pop ax                             ; restore registers modified
    ret

;;
;; Resets disk controller
;; Parameters:
;;   dl: drive number
;;
disk_reset:
    pusha
    mov ah, 0
    stc
    int 0x13
    jc floppy_error
    popa
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
