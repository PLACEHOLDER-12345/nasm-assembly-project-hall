DEFAULT REL
GLOBAL  main

EXTERN  scanf
EXTERN  printf
EXTERN  ExitProcess

SECTION .data
    int1msg db "Enter 1st int: ", 10, 0
    int2msg db "Enter 2nd int: ", 10, 0
    opermsg db "Choose operation (+ - * /): ", 10, 0
    invopmsg db "Invalid operator - enter one of +, -, *, /", 10, 0
    resultmsg db "Result: %d", 10, 0
    divresmsg db "Result: %f", 10, 0
    div0msg db "Can't divide by zero...", 10, 0
    scanfmt1 db "%d", 0
    scanfmt2 db " %1c", 0 ; one character
SECTION .text

main:
    PUSH rbp
    MOV rbp, rsp 
    SUB rsp, 48

    MOV DWORD [rbp - 4], 0 ; int 1
    MOV DWORD [rbp - 8], 0 ; int 2
    MOV BYTE [rbp - 9], 0 ; char

    LEA rcx, [int1msg]
    CALL printf

    LEA rcx, [scanfmt1]
    LEA rdx, [rbp - 4]
    CALL scanf

    LEA rcx, [int2msg]
    CALL printf

    LEA rcx, [scanfmt1]
    LEA rdx, [rbp - 8]
    CALL scanf

    LEA rcx, [opermsg]
    CALL printf

    LEA rcx, [scanfmt2]
    LEA rdx, [rbp - 9]
    CALL scanf

    CMP BYTE [rbp - 9], 43 ; +
    JE .L4
    CMP BYTE [rbp - 9], 45 ; -
    JE .L5
    CMP BYTE [rbp - 9], 42 ; *
    JE .L6
    CMP BYTE [rbp - 9], 47 ; /
    JE .L7

.L3:
    LEA rcx, [invopmsg]
    CALL printf
    JMP .L9

.L4:
    LEA rcx, [resultmsg]
    MOV DWORD edx, [rbp - 4]
    ADD DWORD edx, [rbp - 8]
    CALL printf
    JMP .L9

.L5:
    LEA rcx, [resultmsg]
    MOV DWORD edx, [rbp - 4]
    SUB DWORD edx, [rbp - 8]
    CALL printf
    JMP .L9

.L6:
    LEA rcx, [resultmsg]
    MOV DWORD edx, [rbp - 4]
    IMUL DWORD edx, edx, [rbp - 8]
    CALL printf
    JMP .L9

.L7:
    CMP DWORD [rbp - 8], 0 ; check for div/0
    JE .L8

    CVTSI2SS xmm0, DWORD [rbp - 4]
    CVTSI2SS xmm1, DWORD [rbp - 8]

    DIVSS xmm0, xmm1
    CVTSS2SD xmm0, xmm0 ; double for printf

    LEA rcx, [rel divresmsg]
    MOV al, 1 ; 1 float arg
    CALL printf
    JMP .L9

.L8:
    LEA rcx, [rel div0msg]
    CALL printf
    JMP .L9

.L9: ; end
    ADD rsp, 48
    POP rbp

    XOR ecx, ecx
    CALL ExitProcess