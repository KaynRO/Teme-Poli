%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;cele doua multimi se gasesc in eax si ebx
    mov eax, 139 
    mov ebx, 169
    PRINT_DEC 4, eax ; afiseaza prima multime
    NEWLINE
    PRINT_DEC 4, ebx ; afiseaza cea de-a doua multime
    NEWLINE

    mov edx, eax        ; TODO1: reuniunea a doua multimi
    or edx, ebx
    PRINT_DEC 4, edx
    NEWLINE

    mov edx, 10 
    or eax, edx
    PRINT_DEC 4, eax    ; TODO2: adaugarea unui element in multime
    NEWLINE

    mov edx, eax
    and edx, ebx       ; TODO3: intersectia a doua multimi
    PRINT_DEC 4, edx
    NEWLINE

    mov edx,eax         ; TODO4: complementul unei multimi
    not edx
    PRINT_DEC 4, edx
    NEWLINE

    mov edx, 25
    sub eax, edx 
    PRINT_DEC 4, eax
    NEWLINE             ; TODO5: eliminarea unui element


    mov edx, eax        ; TODO6: diferenta de multimi EAX-EBX
    and edx, ebx
    sub eax, edx
    PRINT_DEC 4, eax
    NEWLINE
    
    xor eax, eax
    ret
