BITS 32
extern print_line
extern puts
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

; SAMPLE FUNCTION
; Description: adds two integers and returns their sum
; @arg1: int a - the first number
; @arg2: int b - the second number
; Return value: int
; Suggested name: add
mystery0:
  push ebp
  mov ebp, esp
  mov eax, [ebp+8]
  mov ebx, [ebp+12]
  add eax, ebx
  leave
  ret

; Description: find string length
; @arg1: char* a - string
; Return value: int
; Suggested name: strlen
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

; Description: find character position
; @arg1: char* a - string
; @arg2: char b - character
; Return value: int
; Suggested name: strpos
mystery2:
  push ebp
  mov ebp, esp
    
  mov edi, [ebp + 8]
  mov cl, [ebp + 12]
  xor eax, eax
  
mystery2_loop:
  cmp byte[edi], 0x0
  je mystery2_error
  cmp byte[edi], cl
  je mystery2_end
  inc edi
  inc eax
  jmp mystery2_loop
  
  
mystery2_error:
  test eax, eax
  jne mystery2_end
  mov eax, 0xffffffff
  
mystery2_end:
  leave
  ret

; Description: check same prefix
; @arg1: char* a - first string
; @arg2: char* b - second string
; @arg3: int x - prefix length
; Return value: bool
; Suggested name: same_prefix
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

; Description: copy string into another
; @arg1: char* a - first string
; @arg2: char* b - second string
; @arg3: int x - length
; Return value: void
; Suggested name: strcpy
mystery4:
  push ebp
  mov ebp, esp
  
  mov edi, [ebp + 8]
  mov esi, [ebp + 12]
  mov ecx, [ebp + 16]
  
  repne movsb
  
  leave
  ret

; Description: check if character is digit
; @arg1: char a - character
; Return value: bool
; Suggested name: is_digit
mystery5:
  push ebp
  mov ebp, esp
  
  mov edx, [ebp + 8]
  xor eax, eax
  cmp dl, '0'
  jl mystery5_end
  cmp dl, '9'
  jg mystery5_end
  inc eax

mystery5_end:   
  leave
  ret

; Description: reverse string
; @arg1: char* a - string
; Return value: void
; Suggested name: revert
mystery6:
  push ebp
  mov ebp, esp
  
  mov edi, [ebp + 8]
  push edi
  call mystery1
  add esp, 4
  
  mov edi, [ebp + 8]
  mov esi, eax
  shr eax, 1
  mov ecx, 1
  
mystery6_loop:
  mov dl, byte[edi + esi - 1]
  mov dh, byte[edi + ecx - 1]
  mov byte[edi + ecx - 1], dl
  mov byte[edi + esi - 1], dh
  dec esi
  inc ecx
  dec eax
  test eax, eax
  jne mystery6_loop
  
  leave
  ret

; Description: convert char to int
; @arg1: char* a - first string
; Return value: int
; Suggested name: atoi
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

; Description: check if string1 contains prefix of string2
; @arg1: char* a - first string
; @arg2: char* b - second string
; @arg3: int x - prefix length
; Return value: bool
; Suggested name: contains_prefix
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
  mov eax, 1
  jmp mystery8_end
     
mystery8_not:
  mov eax, 0
  
mystery8_end:
  pop ebx
  leave
  ret

; Description: find string into text limits
; @arg1: char* a - first string
; @arg2: int start - left limit
; @arg3: int end - right limit
; @arg4: char* b - second string
; Return value: void
; Suggested name: strstr
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
  
  ;pusha
  ;add ebx, esi
  ;push ebx
  ;call print_line
  ;add esp, 4
  ;popa
  
mystery9_continue:
  mov ebx, ecx
  inc ebx
  jmp mystery9_loop
  
mystery9_end:
  pop ebx
  leave
  ret
