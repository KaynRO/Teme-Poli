global computeLength
global computeLength2

section .text
computeLength:
    push ebp
    mov ebp, esp

    xor eax, eax
    xor ecx, ecx
    mov esi, [ebp + 8]
    
bit_loop:  
    inc eax
    mov cl, byte[esi]
    inc esi
    cmp cl, 0x00
    jne bit_loop

    mov esp, ebp
    pop ebp
    ret

computeLength2:
    push ebp
    mov ebp, esp

    xor eax, eax
    xor ecx, ecx
    not ecx
    mov edi, [ebp + 8]
    
    mov al, 0x00
    repne scasb
    neg ecx
    dec ecx
    xchg eax, ecx
    
    mov esp, ebp
    pop ebp
    ret
