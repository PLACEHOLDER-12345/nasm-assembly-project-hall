GLOBAL main
DEFAULT rel

EXTERN printf
EXTERN ExitProcess

SECTION .data
    guy_fmt db "Name: %s, Age: %d", 10, 0

    guy_1 db "John", 0, 0, 0, 0, 30, 0 ; name (8 bytes), age (2 bytes)
    guy_2 db "Jane", 0, 0, 0, 0, 25, 0 ; name (8 bytes), age (2 bytes)

SECTION .text

print_guy: ; takes the beginning pointer to a guy struct from rcx.
; declaration: void print_guy(guy *g);
    MOV r9, rcx                    ; save struct pointer in r9
    LEA rcx, [guy_fmt]             ; rcx = format string
    LEA rdx, [r9]                  ; rdx = pointer to name
    MOVZX r8, word [r9 + 8]        ; r8 = age (word at offset 8)
    CALL printf
    RET

main:
    MOV rcx, guy_1
    CALL print_guy
    MOV rcx, guy_2
    CALL print_guy