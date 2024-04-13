; Set origin address
ORG 0

; Tell the assembler that we are using 16bit architecture
BITS 16

_start:
    jmp short start
    nop

 times 33 db 0 ; create 33 bytes after short jump for the bios to fill them instead of corrupting our code

start:
    jmp 0x7c0:step2 ; make the code segment 07xc0

step2:
    cli ; Clear Interrupts
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    ;Setup the stack segment
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    sti ; Enables Interrupts
    mov si, message
    call print
    ; keep humping to the same line
    jmp $

print:
    ; Page number (this is not necessary at the moment)
    mov bx, 0
.loop:
    ; Load the character of the si register into the al register and increment the register
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop
;sublable
.done:
    ret

print_char:
    ; move a value into the ah register
    mov ah, 0eh
    ; Call the bios: int is for interrup: search Ralf Brown's enterupt list
    int 0x10
    ;return from subroutine
    ret

message: db 'Hello World!', 0

; We need to fill at least 510 byte of data and pad the rest with zeros
; The boot siganture should be at byte 511 and 512
times 510-($ - $$) db 0
dw 0xAA55