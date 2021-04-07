%include "io.inc"


section .data
%define NUM 5
    output times NUM dd 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp

    mov ecx, NUM
push_nums:
    mov dword[output + 4 * ecx - 4], ecx
    push ecx
    loop push_nums

    push 0
    push "mere"
    push "are "
    push "Ana "

    PRINT_STRING [esp]
    NEWLINE
    
    mov ecx, 5
    lea edx, [esp]
    lea ebx, [ebp]

pop_nums:
    PRINT_HEX 4, ebx
    PRINT_STRING ": "
    PRINT_HEX 4, [ebx]
    NEWLINE
    
    sub ebx, 4
    cmp edx, ebx
    jle pop_nums

    mov esp, ebp

    ; exit without errors
    xor eax, eax
    ret
