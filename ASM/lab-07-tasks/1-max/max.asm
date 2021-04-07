%include "io.inc"

section .text
global CMAIN
CMAIN:
    ; cele doua numere se gasesc in eax si ebx
    mov eax, 2
    mov ebx, 10

    cmp ebx, eax
    jg change
    
change:
    push ebx
    push eax
    pop eax
    pop ebx

    PRINT_DEC 4, eax ; afiseaza minimul
    NEWLINE

    ret
