%include "io.inc"

section .data
    num dd 100
    print_format1 db "Sum(", 0
    print_format2 db "): ", 0

section .text
global CMAIN
CMAIN:
    push ebp
    mov ebp, esp

    mov ecx, [num]     ; Use ecx as counter for computing the sum.
    xor ebx, ebx       ; Use eax to store the sum. Start from 0.

add_to_sum:
    mov eax, ecx
    mul ecx            ; Multiply the current number with itself
    add ebx, edx       ; Add higher value and lower
    add ebx, eax
    loop add_to_sum    ; Decrement ecx. If not zero, add it to sum.

    mov ecx, [num]
    PRINT_STRING print_format1
    PRINT_UDEC 4, ecx
    PRINT_STRING print_format2
    PRINT_UDEC 4, ebx
    NEWLINE

    leave
    ret
