; hello world on a VGA screen on text mode

BITS 16                          ; 16-bit real mode
ORG 0x7C00                       ; bootloader

start:
    MOV ax, 0x0003              ; set text mode
    INT 0x10                    ; VGA interrupt

    MOV ax, 0xB800              ; VGA text mode memory segment
    MOV es, ax                  ; VGA text buffer on 0xB8000
    XOR di, di                  ; Start at offset 0

    MOV ah, 0x0F                ; White text on black background
    MOV si, msg                 ; Load message address
.L2:
    LODSB                       ; Load byte from [si] into al, equivalent to mov al, [si]; inc si
    TEST al, al                 ; Check for null terminator
    JZ .L5

    CMP al, 0xA                 ; newline
    JE .L3

    CMP al, 0xD                 ; CR

    MOV [es:di], ax             ; Write character and attribute
    ADD di, 2                   ; Move to next character position
    JMP .L2
.L3: ; newline
    MOV bx, di ; save DI for later
    MOV dx, 0
    MOV cx, 160
    DIV cx ; dx:ax /= 160, quotient in ax (line num), remainder in dx (column num)

    SUB di, dx ; move back to the start
    ADD di, 160 ; next line
    JMP .L2 ; continue on with the print loop
.L4:
    MOV bx, di
    MOV dx, 0
    MOV cx, 160
    DIV cx ; dx:ax /= 160, line num in ax, column num in dx

    SUB di, dx ; move back to the start
.L5: ; done - shutdown code
    HLT                         ; Halt CPU
    JMP $

msg: db "Hello world!", 10, "This is", 13, "This is VGA speaking", 0
; test string with newline and carriage return

times 510 - ($ - $$) db 0       ; Pad to 510 bytes
dw 0xaa55                       ; Boot signature - must have