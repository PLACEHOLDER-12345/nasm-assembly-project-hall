; demonstration of local variables in NASM stored on stack (and a few globals)

DEFAULT rel
GLOBAL main

EXTERN printf
EXTERN ExitProcess

SECTION .data:
    global_var dd 100 ; int global_var = 100
    printf_fmt db "Local variable: %d", 10, 0
    printf_fmt_2 db "Global variable: %d", 10, 0

SECTION .text:

main:
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 16 + 32 ; shadow space & 16 bytes

    MOV DWORD [rbp - 4], 10 ; int localvar = 10
    LEA rcx, [printf_fmt]
    MOV edx, DWORD [rbp - 4]
    CALL printf
    
    LEA rcx, [printf_fmt_2]
    MOV edx, DWORD [global_var]
    CALL printf

    ADD rsp, 16 + 32
    POP rbp
    XOR ecx, ecx
    CALL ExitProcess