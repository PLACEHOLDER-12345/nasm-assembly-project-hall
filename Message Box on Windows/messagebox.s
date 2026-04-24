DEFAULT rel

extern MessageBoxA
extern ExitProcess

GLOBAL main

SECTION .data
    title db "Hello Box", 0
    message db "Hello from NASM!", 0

SECTION .text
main:
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 32

    XOR  rcx, rcx
    LEA  rdx, [message]
    LEA  r8, [title]
    XOR  r9, r9
    CALL MessageBoxA

    ADD rsp, 32
    POP rbp

    XOR  ecx, ecx
    CALL ExitProcess