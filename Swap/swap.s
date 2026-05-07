GLOBAL main
DEFAULT rel

; std library functions
EXTERN printf
; windows API functions
EXTERN ExitProcess

SECTION .rdata
    LC0 db "Before: x = %d, y = %d", 10, 0
    LC1 db "After: x = %d, y = %d", 10, 0

SECTION .text
swap:
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 48

    ; temp = *x
    MOV eax, DWORD [rcx]
    MOV DWORD [rbp - 4], eax

    ; *x = *y
    MOV eax, DWORD [rdx]
    MOV DWORD [rcx], eax

    ; *y = temp
    MOV eax, DWORD [rbp - 4]
    MOV DWORD [rdx], eax

    ADD rsp, 48
    POP rbp

    RET

main:
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 48

    MOV DWORD [rbp - 4], 6 ; int x = 6
    MOV DWORD [rbp - 8], 3 ; int y = 3

    LEA rcx, [LC0]
    MOV edx, DWORD [rbp - 4]
    MOV r8d, DWORD [rbp - 8]
    CALL printf

    LEA rcx, [rbp - 4] ; *x
    LEA rdx, [rbp - 8] ; *y
    CALL swap

    LEA rcx, [LC1]
    MOV edx, DWORD [rbp - 4]
    MOV r8d, DWORD [rbp - 8]
    CALL printf

    ADD rsp, 48
    POP rbp

    XOR ecx, ecx
    CALL ExitProcess