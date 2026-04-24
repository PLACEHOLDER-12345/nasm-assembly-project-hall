; sum an array of ints

DEFAULT rel
GLOBAL  main

EXTERN  printf
EXTERN  ExitProcess

SECTION .DATA
    data        dd 1,2,3,4,5,6,7,8,9,10
    data_len    equ ($ - data) / 4

    fmt         db "Sum = %d", 10, 0

SECTION .TEXT

calculate_sum:
    XOR     eax, eax          ; sum
    XOR     r8d, r8d          ; i

.L2:
    CMP     r8d, edx
    JGE     .L3

    ADD     eax, DWORD [rcx + r8*4]  ; sum += arr[i]
    INC     r8d
    JMP     .L2

.L3:
    RET

; main
main:
    ; Reserve shadow space (32 bytes) and align.
    SUB     rsp, 40
    ; CALL CALCULATE_SUM(DATA, DATA_LEN)
    LEA     rcx, [data]       ; ARG1 = &DATA
    MOV     edx, data_len         ; ARG2 = COUNT
    CALL    calculate_sum         ; RAX <- SUM
    ADD     rsp, 40

    SUB     rsp, 40
    ; PRINTF("Sum = %d\n", SUM)
    LEA     rcx, [fmt]        ; ARG1 = FORMAT
    MOV     edx, eax              ; ARG2 = SUM (INT)
    CALL    printf
    ADD     rsp, 40

    SUB     rsp, 40
    ; ExitProcess(0)
    XOR     ecx, ecx
    CALL    ExitProcess
