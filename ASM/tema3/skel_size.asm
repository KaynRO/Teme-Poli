BITS 32
extern print_line
global mystery1:function
global mystery2:function
global mystery3:function
global mystery4:function
global mystery5:function
global mystery6:function
global mystery7:function
global mystery8:function
global mystery9:function

section .text

mystery0:
  push ebp
  mov ebp, esp
  mov eax, [ebp+8]
  mov ebx, [ebp+12]
  add eax, ebx
  leave
  ret

mystery1:
  push ebp
  mov ebp, esp
  
  mov edi, [ebp + 8]
  xor al, al
  xor ecx, ecx
  not ecx
  
  repne scasb
  not ecx
  dec ecx
  mov eax, ecx  
  
  leave
  ret
  
mystery2:
  push ebp
  mov ebp, esp
  
  mov edi, [ebp + 8]
  push edi
  call mystery1
  add esp, 4
  
  mov ecx, eax
  test ecx, ecx
  je mystery2_error
  
  mov edi, [ebp + 8]
  mov al, [ebp + 12]
  
  repne scasb
  sub edi, [ebp + 8]
  dec edi
  jmp mystery2_end
  
mystery2_error:
  mov edi, 0xffffffff
  
mystery2_end:
  mov eax, edi
  leave
  ret

mystery3:
  push ebp
  mov ebp, esp
  
  mov esi, [ebp + 8]
  mov edi, [ebp + 12]
  mov ecx, [ebp + 16]
  inc ecx
  xor eax, eax
  
  repe cmpsb
  jecxz mystery3_end
  
mystery3_not:
  inc eax

mystery3_end:
  leave
  ret

mystery4:
  push ebp
  mov ebp, esp
  
  mov edi, [ebp + 8]
  mov esi, [ebp + 12]
  mov ecx, [ebp + 16]
  
  repne movsb
  
  leave
  ret

mystery7:
  push ebp
  mov ebp, esp
  
  mov edi, [ebp + 8]
  push edi
  call mystery1
  add esp, 4
  
  mov edi, [ebp + 8]
  xor ecx, ecx
  xor edx, edx
  xchg edx, eax
  
mystery7_loop:
  movzx esi, byte[edi]
  dec edx
  inc edi
  cmp esi, '0'
  jb mystery7_end
  cmp esi, '9'
  ja mystery7_end
  sub esi, '0'
  imul eax, 10
  add eax, esi
  test edx, edx
  jne mystery7_loop
  
mystery7_end:
  leave
  ret

mystery8:
  push ebp
  mov ebp, esp
  push ebx
  
  mov edi, [ebp + 8]
  mov esi, [ebp + 12]
  
  xor ebx, ebx
  xor edx, edx
  xor eax, eax
  
mystery8_loop:
  cmp ebx, [ebp + 16]
  jge mystery8_not
  
  mov al, byte[edi + edx]
  test eax, eax
  je mystery8_not
  
  cmp al, 10d
  je mystery8_not
  
  cmp al, byte[esi + ebx]
  je mystery8_equal
  xor ebx, ebx
  
mystery8_continue:
  cmp ebx, [ebp + 16]
  je mystery8_yes
  inc edx
  jmp mystery8_loop
  
mystery8_equal:
  inc ebx
  jmp mystery8_continue

mystery8_yes:
  mov al, 1
  jmp mystery8_end
     
mystery8_not:
  mov al, 0
  
mystery8_end:
  pop ebx
  leave
  ret

mystery9:
  push ebp
  mov ebp, esp
  push ebx
  
  mov edi, [ebp + 20]
  
  push edi
  call mystery1
  add esp, 4
  
  mov esi, [ebp + 8]
  mov ecx, [ebp + 12]
  mov edi, [ebp + 20]
  mov ebx, ecx
  dec ecx
   
mystery9_loop:
  inc ecx
  cmp ecx, [ebp + 16]
  jge mystery9_end
  cmp byte[esi + ecx], 0xa
  jne mystery9_loop
  
  pusha
  push eax
  push edi
  add ebx, esi
  push ebx
  call mystery8
  add esp, 12d

  cmp eax, 1
  popa
  jne mystery9_continue
  
  pusha
  add ebx, esi
  push ebx
  call print_line
  add esp, 4
  popa
  
mystery9_continue:
  mov ebx, ecx
  inc ebx
  jmp mystery9_loop
  
mystery9_end:
  pop ebx
  leave
  ret
