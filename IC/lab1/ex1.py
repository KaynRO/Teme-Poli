from utils import *

C1 = "010101100110000101101100011010000110000101101100011011000110000100100001"
C2 = "526f636b2c2050617065722c2053636973736f727321"
C3 = "WW91IGRvbid0IG5lZWQgYSBrZXkgdG8gZW5jb2RlIGRhdGEu"

print("[+] Decoded strings are:")
print("C1: " + bin_2_str(C1))
print("C2: " + hex_2_str(C2))
print("C3: " + b64decode(C3))