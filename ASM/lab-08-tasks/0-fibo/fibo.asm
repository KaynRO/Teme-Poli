%include "io.inc"

%define NUM_FIBO 10

section .text
global CMAIN

CMAIN:
    mov ebp, esp
    xor edx, edx
    xor ebx, ebx
    inc edx
    inc ebx

    sub esp, NUM_FIBO * 4
    mov ecx, NUM_FIBO - 2
    
    push edx ; first 2 numbers of fibo sequence
    push ebx
    push ecx    ; how many
    
    call fibo
    add esp, 12
    
    
fibo:
    push ebp
    mov ebp, esp
    
    mov eax, [ebp + 8]
    mov ebx, [ebp + 12]
    mov edx, [ebp + 16]
    
recursive: 
    add ebx, edx
    push ebx
    
    cmp eax, 0
    je print
    dec eax

    leave
    ret
    
print:
    PRINT_UDEC 4, [esp + (ecx - 1) * 4]
    PRINT_STRING " "
    dec ecx
    cmp ecx, 0
    ja print

    mov esp, ebp
    xor eax, eax
    ret
