DEFAULT rel
GLOBAL  main

EXTERN  printf
EXTERN  ExitProcess

SECTION .data
    before db "Before: %d", 10, 0
    after db "After: %d", 10, 0

SECTION .text

main:
    PUSH rbp
    MOV rbp, rsp
    PUSH rbx  ; preserve rbx
    SUB rsp, 48 ; 16B local + 32B shadow

    MOV DWORD [rbp - 4], 10 ; score = 10
    LEA rbx, [rbp - 4] ; int *ptr = &score;

    LEA rcx, [before]
    MOV edx, DWORD [rbx] ; *ptr
    CALL printf

    MOV DWORD [rbx], 25

    LEA rcx, [after]
    MOV edx, DWORD [rbx] ; *ptr
    CALL printf

    ADD rsp, 48
    POP rbx  ; restore rbx
    POP rbp
    XOR ecx, ecx
    CALL ExitProcess