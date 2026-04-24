; hello world in ARM

.global _start

.text
_start:
    mov r0, #1          @ stdout
    ldr r1, =msg        @ pointer to string
    mov r2, #13         @ length
    mov r7, #4          @ syscall: write
    svc #0

    mov r0, #0          @ exit code
    mov r7, #1          @ syscall: exit
    svc #0

.data
msg:
    .byte "Hello World!\n"