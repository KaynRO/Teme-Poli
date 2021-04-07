%include "io.inc"

section .data

%define ARRAY_LEN 7

    input dd 122, 184, 199, 242, 263, 845, 911
    output times ARRAY_LEN dd 0

section .text
global CMAIN
CMAIN:
    mov ecx, ARRAY_LEN
pushElem:
    push dword[input + 4 * ecx - 4]
    loop pushElem

    mov ecx, ARRAY_LEN
popElem:
    pop dword[output + 4 * ecx - 4]
    loop popElem
    
    PRINT_STRING "Reversed array:"
    NEWLINE
    xor ecx, ecx
print_array:
    PRINT_UDEC 4, [output + 4 * ecx]
    NEWLINE
    inc ecx
    cmp ecx, ARRAY_LEN
    jb print_array

    xor eax, eax
    ret
