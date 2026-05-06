; multi-file projects

GLOBAL main
DEFAULT rel

EXTERN printf
EXTERN ExitProcess
EXTERN addints

SECTION .rdata
    fmt db "Sum is: %d", 0

SECTION .text
main:
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 32

    MOV ecx, 5
    MOV edx, 4
    CALL addints

    LEA rcx, [fmt]
    MOV edx, eax

    CALL printf

    ADD rsp, 32
    POP rbp

    XOR ecx, ecx
    CALL ExitProcess