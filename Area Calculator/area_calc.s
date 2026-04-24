; Area calculator for various shapes

DEFAULT rel
GLOBAL main

EXTERN printf
EXTERN scanf
EXTERN ExitProcess

SECTION .data
    π dq 3.14159265358979323846
SECTION .bss
    rectlen resq 1 ; double
    rectwidth resq 1 ; double
    circradius resq 1 ; double
    triabsp resq 1 ; double
    triheight resq 1 ; double
    result resq 1 ; double
    choice resb 1 ; char
SECTION .rodata
    shapeprompt db "Pick a shape:", 10, "1. Rectangle", 10, "2. Circle", 10, "3. Triangle", 10, 0
    rectlenprompt db "Enter the length of the rectangle: ", 0
    rectwidthprompt db "Enter the width of the rectangle: ", 0
    circprompt db "Enter the radius of the circle: ", 0
    triabsprompt db "Enter the base of the triangle: ", 0
    triheightprompt db "Enter the height of the triangle: ", 0
    resultstr db "The area is: %f", 10, 0
    debugfmt db "raw=0x%llx", 10, 0
    errorstr db "Invalid choice.", 10, 0
    scanfmt db " %c", 0
    scanfmt2 db " %lf", 0

    two dq 2.0
SECTION .text

main:
    sub rsp, 40
    LEA rcx, [shapeprompt]
    MOV AL, 0
    CALL printf
    LEA rcx, [scanfmt]
    MOV AL, 0
    LEA rdx, [choice]
    CALL scanf

    MOV al, [choice]
    CMP al, '1'
    JE .L2
    CMP al, '2'
    JE .L3
    CMP al, '3'
    JE .L4
    JMP .L5 ; error
.L2: ; rectangle
    LEA rcx, [rectlenprompt]
    MOV AL, 0
    CALL printf
    LEA rcx, [scanfmt2]
    MOV AL, 0
    LEA rdx, [rectlen]
    CALL scanf
    LEA rcx, [debugfmt]
    MOV rdx, [rectlen]
    MOV AL, 0
    CALL printf
    LEA rcx, [rectwidthprompt]
    MOV AL, 0
    CALL printf
    LEA rcx, [scanfmt2]
    MOV AL, 0
    LEA rdx, [rectwidth]
    CALL scanf

    ; do the maths
    MOVSD xmm0, [rectlen]
    MOVSD xmm1, [rectwidth]
    MULSD xmm0, xmm1
    MOVSD [result], xmm0
    LEA rcx, [debugfmt]
    MOV rdx, [result]
    MOV AL, 0
    CALL printf

    ; print the result
    LEA rcx, [resultstr]
    MOV RDX, [result]
    MOVSD xmm1, [result]
    MOV AL, 0
    CALL printf
    JMP .L6
.L3: ; circle
    LEA rcx, [circprompt]
    MOV AL, 0
    CALL printf

    LEA rcx, [scanfmt2]
    MOV AL, 0
    LEA rdx, [circradius]
    CALL scanf

    ; do the maths
    MOVSD xmm0, [circradius]
    MULSD xmm0, xmm0 ; r^2
    MOVSD xmm1, [π]
    MULSD xmm0, xmm1 ; πr^2
    MOVSD [result], xmm0

    ; print the result
    LEA rcx, [resultstr]
    MOV RDX, [result]
    MOVSD xmm1, [result]
    MOV AL, 0
    CALL printf
    JMP .L6
.L4: ; triangle
    LEA rcx, [triabsprompt]
    MOV AL, 0
    CALL printf
    LEA rcx, [scanfmt2]
    MOV AL, 0
    LEA rdx, [triabsp]
    CALL scanf
    LEA rcx, [triheightprompt]
    MOV AL, 0
    CALL printf
    LEA rcx, [scanfmt2]
    MOV AL, 0
    LEA rdx, [triheight]
    CALL scanf

    ; do the maths
    MOVSD xmm0, [triabsp]
    MOVSD xmm1, [triheight]
    MULSD xmm0, xmm1 ; base * height
    DIVSD xmm0, [two] ; (base * height) / 2
    MOVSD [result], xmm0

    ; print the result
    LEA rcx, [resultstr]
    MOV RDX, [result]
    MOVSD xmm1, [result]
    MOV AL, 0
    CALL printf
    JMP .L6
.L5: ; error
    LEA rcx, [errorstr]
    MOV AL, 0
    CALL printf
.L6: ; finish
    ADD rsp, 40
    XOR rcx, rcx
    CALL ExitProcess