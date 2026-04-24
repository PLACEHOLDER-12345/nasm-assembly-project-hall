DEFAULT rel
GLOBAL  main

EXTERN  ExitProcess

SECTION .text
main:
    XOR ecx, ecx
    CALL ExitProcess