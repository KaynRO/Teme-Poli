extern printf
global main

section .data
    str: db "Clock ticks: %d", 10, 13

section .text

    ; TODO:
    ; 1. call rdtsc
    ; 2. save the the value from eax to another register
    ; 3. implement the loop using loop, then a jump instruction
    ; 4. call rdtsc again
    ; 5. subtract from eax the former value of eax
    
main:
    push ebp
    mov ebp, esp

    mov ecx, 1000
    xor eax, eax
    xor ebx, ebx
    rdtsc
    mov ebx, eax

myloop:
    loop myloop
     
    rdtsc
    sub eax, ebx
    
    push eax
    push str
    call printf
    add esp, 8
    
    xor eax, eax
    xor ebx, ebx
    mov ecx, 1000
    rdtsc
    mov ebx, eax

myloop2:
    dec ecx
    cmp ecx, 0
    jge myloop2
    
    rdtsc
    sub eax, ebx

    push eax
    push str
    call printf
    add esp, 8

    mov esp, ebp
    pop ebp
    ret
