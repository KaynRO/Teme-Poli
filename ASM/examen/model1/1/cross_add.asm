%include "io.inc"

section .data
    arr1 dd 1,2,3,4,5,6,7,8,9,10
    arr2 dd 11,12,13,14,15,16,17,18,19,20
    num dd 10

section .bss
    res resd 10

section .text
global main

main:
    push ebp
    mov ebp, esp

    ; List first and last item in each array.
    PRINT_UDEC 4, [arr1]
    NEWLINE
    PRINT_UDEC 4, [arr2]
    NEWLINE
    PRINT_UDEC 4, [res]
    NEWLINE

    PRINT_UDEC 4, [arr1+36]
    NEWLINE
    PRINT_UDEC 4, [arr2+36]
    NEWLINE
    PRINT_UDEC 4, [res+36]
    NEWLINE

    ; TODO b: Compute res[0] and res[n-1].
    
    mov ecx, [num]
    dec ecx
    
    mov eax, dword[arr1]
    add eax, dword[arr2 + 4 * ecx]
    mov [res], eax
    
    mov eax, dword[arr2]
    add eax, dword[arr1 + 4 * ecx]
    mov [res + 4 * ecx], eax
   
    ; TODO d: Compute cross sums in res[i].

    xor edx, edx
    
compute:
    inc edx
    dec ecx
    mov eax, dword[arr1 + 4 * edx]
    add eax, dword[arr2 + 4 * ecx]
    mov dword[res + 4 * edx], eax
    cmp ecx, 1
    jge compute
    
    ; TODO c: List arrays.

    mov ecx, [num]
    dec ecx
    mov edx, -1
    
repeat1:
    inc edx
    PRINT_UDEC 4, [arr1 + 4 * edx]
    cmp edx, ecx
    jne repeat1

    NEWLINE
    
    mov edx, -1
    
repeat2:
    inc edx
    PRINT_UDEC 4, [arr2 + 4 * edx]
    cmp edx, ecx
    jne repeat2

    NEWLINE
    
    mov edx, -1
    
repeat3:
    inc edx
    PRINT_UDEC 4, [res + 4 * edx]
    cmp edx, ecx
    jne repeat3

    NEWLINE

    ; Return 0.    
    xor eax, eax
    leave
    ret