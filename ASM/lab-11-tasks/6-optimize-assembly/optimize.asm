global runAssemblyCode

extern printf

section .data
    str: db "%d",10,13

section .text
runAssemblyCode:
    push ebp
    mov ebp, esp

    ; N
    sub esp, 4
    mov eax, [ebp+12]
    mov dword[esp], eax

    ; i
    sub esp, 4
    ; sum
    sub esp, 4
    mov dword[esp], 0
    ; int* a
    sub esp, 4
    mov eax, [ebp+8]
    mov [esp], eax

    mov eax, [ebp-4]
    mov dword[ebp-8], 0
    jmp L1

L2:
    mov [ebp-4], eax    ; length of vector
    mov eax, [ebp-8]    ; eax = i
    mov edx, [ebp-16]
    
    lea eax, [edx + 4*eax] ; eax = *v[i]
    mov edx, [eax]  ; edx = v[i]
    add [ebp-12], edx   ; sum += edx
    
    add dword[ebp-8], 1 ; i++
    mov eax, [ebp-4]    ; eax = len(v)
    
    mov [ebp-4], eax    ; length of vector
    mov eax, [ebp-8]    ; eax = i
    mov edx, [ebp-16]
    
    lea eax, [edx + 4*eax] ; eax = *v[i]
    mov edx, [eax]  ; edx = v[i]
    add [ebp-12], edx   ; sum += edx
    
    add dword[ebp-8], 1 ; i++
    mov eax, [ebp-4]    ; eax = len(v)

L1:
    ; if i < N
    cmp [ebp-8], eax
    jl L2

    mov eax, [ebp-12]
    mov esp, ebp
    pop ebp
    ret
