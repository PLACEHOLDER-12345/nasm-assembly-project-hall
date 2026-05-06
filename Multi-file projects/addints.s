GLOBAL addints

SECTION .text

addints: ; first addend in ecx, second in edx
    MOV eax, ecx
    ADD eax, edx
    RET