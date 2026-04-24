; bubble sort demo

GLOBAL main
DEFAULT rel

EXTERN printf
EXTERN ExitProcess

SECTION .data
    array dd 64, 34, 25, 12, 22, 11, 90, 34
    arr_len dd 8
    fmt db "The sorted array is: ", 10, 0
    num_fmt db "%d, ", 0

SECTION .text
swap: ; takes pointers to 2 ints in rcx & rdx
    MOV eax, [rcx] ; load *a
    MOV edx, [rdx] ; load *b
    MOV [rcx], edx ; store *b into *a
    MOV [rdx], eax ; store original *a into *b
    RET

bubble_sort:
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 32 ; shadow space & locals

    MOV QWORD [rbp + 16], rcx ; array pointer
    MOV DWORD [rbp + 24], edx ; length

    MOV DWORD [rbp - 4], 0 ; i = 0
.L2:
    MOV     eax, DWORD [rbp - 4]
    MOV     edx, DWORD [rbp + 24]
    DEC     edx
    CMP     eax, edx
    JGE     .L6

    MOV     DWORD [rbp - 8], 0 ; j = 0
.L3:
    MOV     eax, DWORD [rbp - 8]
    MOV     edx, DWORD [rbp + 24]
    DEC     edx
    SUB     edx, DWORD [rbp - 4]
    CMP     eax, edx
    JGE     .L5

    MOV     eax, DWORD [rbp - 8]
    CDQE
    MOV     r10, QWORD [rbp + 16]
    LEA     r10, [r10 + rax * 4]
    MOV     edx, DWORD [r10]
    MOV     esi, DWORD [r10 + 4]
    CMP     edx, esi
    JLE     .L4
    MOV     DWORD [r10], esi
    MOV     DWORD [r10 + 4], edx
.L4:
    INC     DWORD [rbp - 8]
    JMP     .L3

.L5:
    INC     DWORD [rbp - 4]
    JMP     .L2

.L6:
    LEAVE
    RET

main:
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 96 ; shadow space for local vars

    MOV DWORD [rbp - 8], 8 ; len = 8

    ; arr elements from rbp - 48 to rbp - 16 (32B for 8 ints)
    MOV DWORD [rbp - 48], 64
    MOV DWORD [rbp - 44], 34
    MOV DWORD [rbp - 40], 25
    MOV DWORD [rbp - 36], 12
    MOV DWORD [rbp - 32], 22
    MOV DWORD [rbp - 28], 11
    MOV DWORD [rbp - 24], 90
    MOV DWORD [rbp - 20], 34

    MOV edx, DWORD [rbp - 8] ; len
    LEA rcx, [rbp - 48] ; the array
    CALL bubble_sort

    ; print each el in the sorted array
    MOV DWORD [rbp - 4], 0 ; i = 0
    JMP .L8

.L9:
    MOV eax, DWORD [rbp - 4] ; i
    CDQE
    MOV edx, DWORD [rbp - 48 + rax * 4] ; arr[i]
    LEA rcx, [num_fmt]
    CALL printf

    INC DWORD [rbp - 4] ; i++
    ; JMP .L8 <- optional

.L8:
    MOV eax, DWORD [rbp - 4]
    CMP eax, DWORD [rbp - 8] ; i < len?
    JL  .L9 ; jump if less

    ADD rsp, 96
    POP rbp
    
    XOR ecx, ecx
    CALL ExitProcess