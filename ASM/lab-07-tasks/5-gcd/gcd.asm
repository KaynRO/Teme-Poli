%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ; input values (eax, edx): the 2 numbers to compute the gcd for
    mov eax, 49
    mov edx, 28
    
    mov esi, eax
    mov edi, edx

    push eax
    push edx

gcd:
    neg     eax
    je      L3

L1:
    neg     eax
    push eax
    push edx
    pop eax
    pop edx

L2:
    sub     eax,edx
    jg      L2
    jne     L1

L3:
    add     eax,edx
    jne     print
    inc     eax

print:

    PRINT_STRING "gdc("
    PRINT_UDEC 4, esi
    PRINT_STRING ", "
    PRINT_UDEC 4, edi
    PRINT_STRING ")="

    PRINT_UDEC 4, eax  ; output value in eax
    
    mov esp, ebp
    xor eax, eax
    ret
