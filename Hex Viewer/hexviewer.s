; hex viewer

GLOBAL main
DEFAULT rel

; std library functions
EXTERN printf
EXTERN putchar
EXTERN scanf
EXTERN puts
; windows API functions
EXTERN ExitProcess
EXTERN CreateFileA
EXTERN ReadFile
EXTERN CloseHandle

SECTION .rdata
    LC0 db "Enter file name (must be in the same project folder): ", 10, 0
    LC1 db "%16s", 0
    LC2 db "%06X: ", 0
    LC3 db "%02X ", 0
    LC4 db "CreateFile fail", 0
    LC5 db "   ", 0

SECTION .text
main:
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 128

    LEA rcx, [rel LC0]
    CALL printf

    LEA rcx, [rel LC1]
    LEA rax, [rbp - 32] ; char filenamebuffer[16]
    MOV rdx, rax
    CALL scanf

    LEA rcx, [rbp - 32]
    MOV edx, 0x80000000
    MOV r8d, 0x01
    MOV r9d, 0x00
    MOV DWORD [rsp + 32], 3
    MOV DWORD [rsp + 40], 128
    MOV QWORD [rsp + 48], 0
    CALL CreateFileA
    MOV QWORD [rbp - 16], rax ; hFile

    ; check for invalid
    CMP QWORD [rbp - 16], -1
    JNE .L2
    
    LEA rcx, [rel LC4] ; file handle fail
    CALL puts
    MOV ecx, 1
    CALL ExitProcess
    
.L2:
    MOV DWORD [rbp - 4], 0
    JMP .L3
.L9:
    LEA rcx, [rel LC2]
    MOV edx, DWORD [rbp - 4]
    CALL printf

    MOV DWORD [rbp - 8], 0 ; i
    JMP .L4
.L7:
    MOV eax, DWORD [rbp - 52]
    CMP DWORD [rbp - 8], eax
    JGE .L5

    MOV eax, [rbp - 8]
    CDQE
    MOVZX eax, BYTE [rbp - 48 + rax] ; buffer[i]
    MOVZX eax, al ; keep just the byte
    LEA rcx, [rel LC3]
    MOV edx, eax
    CALL printf
    JMP .L6
.L5:
    LEA rcx, [rel LC5]
    CALL printf
.L6:
    ADD DWORD [rbp - 8], 1
.L4:
    CMP DWORD [rbp - 8], 16
    JL .L7

    MOV ecx, 10
    CALL putchar
    MOV eax, [rbp - 52]
    ADD DWORD [rbp - 4], eax
.L3:
    MOV rcx, [rbp - 16] ; hFile
    LEA rdx, [rbp - 48] ; buffer
    MOV r8d, 16
    LEA r9, [rbp - 52] ; &bytesRead
    MOV QWORD [rsp + 32], 0 ; NULL
    CALL ReadFile

    TEST eax, eax
    JE .L8

    MOV eax, [rbp - 52]
    TEST eax, eax
    JNE .L9
.L8:
    MOV rcx, [rbp - 16]
    CALL CloseHandle

    ADD rsp, 128
    POP rbp

    XOR ecx, ecx
    CALL ExitProcess