DEFAULT rel
GLOBAL main

EXTERN printf
EXTERN ExitProcess

SECTION .rdata
    LC0 db "%d, %d, %d", 10, 0
SECTION .text
main:
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 48

    MOV DWORD [rbp - 4], 0 ; i
    JMP .L2
.L7: ; i loop body
    MOV DWORD [rbp - 8], 0 ; j
    JMP .L3
.L6: ; j loop body
    MOV DWORD [rbp - 12], 0 ; k
    JMP .L4
.L5: ; k loop body
    MOV rcx, LC0 ; "%d, %d, %d\n"
    MOV edx, DWORD [rbp - 4]
    MOV r8d, DWORD [rbp - 8]
    MOV r9d, DWORD [rbp - 12]

    CALL printf

    ADD DWORD [rbp - 12], 1
.L4: ; k condition
    CMP DWORD [rbp - 12], 10
    JL .L5
    ADD DWORD [rbp - 8], 1
.L3: ; j condition
    CMP DWORD [rbp - 8], 10
    JL .L6
    ADD DWORD [rbp - 4], 1
.L2: ; i condition
    CMP DWORD [rbp - 4], 10
    JL .L7
; end
    ADD rsp, 48
    POP rbp

    XOR ecx, ecx
    CALL ExitProcess