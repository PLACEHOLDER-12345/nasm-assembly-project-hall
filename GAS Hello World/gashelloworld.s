.globl main
.extern printf
.extern ExitProcess

.section .data
hello:
    .string "Hello, World!\n"

    .section .text
main:
    PUSHq %rbp
    MOVq %rsp, %rbp
    SUBq  $40, %rsp            # 32 bytes shadow + alignment

    LEAq  hello(%rip), %rcx   # Windows ABI: arg1 in RCX
    CALL  printf@PLT

    XORl  %ecx, %ecx
    CALL  ExitProcess@PLT