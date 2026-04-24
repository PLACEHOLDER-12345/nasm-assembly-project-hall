; 2D array demonstration in assembly
; C Pseudocode:
; int arr[3][4] = {
;     {1, 2, 3, 4},
;     {5, 6, 7, 8},
;     {9, 10, 11, 12}
; }
; int main() {
;     for (i = 0; i < 3; i++) {
;         for (j = 0; j < 4; j++) {
;             printf("%d ", arr[i][j]);
;         }
;         printf("\n");
;     }
;     return 0;
; }

GLOBAL main
DEFAULT rel

EXTERN printf
EXTERN ExitProcess

SECTION .data
    arr dd 1, 2, 3, 4
        dd 5, 6, 7, 8
        dd 9, 10, 11, 12

    fmt db "%d, ", 0
    newline db 10, 0

SECTION .text
main:
    PUSH rbp
    MOV rbp, rsp
    SUB rsp, 48 ; shadow space for local vars
    
    ; setup outer loop (i)
    MOV DWORD [rbp - 4], 0 ; i = 0
.L5:
    MOV DWORD [rbp - 8], 0 ; j = 0
    JMP .L3
.L4:
    ; prepare for SIB maths
    MOV eax, DWORD [rbp - 8] ; j
    CDQE
    MOV edx, DWORD [rbp - 4] ; i
    MOVSX rdx, edx

    LEA r10, [arr]  ; load base address
    MOV r11, rdx    ; i
    SHL r11, 4      ; i * 16
    MOV r12, rax    ; j
    SHL r12, 2      ; j * 4
    ADD r11, r12    ; offset = i*16 + j*4
    LEA rcx, [fmt]
    MOV edx, DWORD [r10 + r11] ; arr[i][j]
    CALL printf

    INC DWORD [rbp - 8] ; j++

.L3:
    CMP DWORD [rbp - 8], 4
    JL .L4 ; go to .L4 if less than 4
    LEA rcx, [newline]
    CALL printf
    INC DWORD [rbp - 4]
.L2:
    CMP DWORD [rbp - 4], 3
    JL .L5 ; go to .L5 if less than 3

    ADD rsp, 48
    POP rbp

    XOR ecx, ecx
    CALL ExitProcess