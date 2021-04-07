from utils import *

C1 = "000100010001000000001100000000110001011100000111000010100000100100011101000001010001100100000101"
C2 = "02030F07100A061C060B1909"

C1_ascii = bin_2_str(C1)
C2_ascii = hex_2_str(C2)

key = "abcdefghijkl"

print("[+] Decoded texts are: ")
print("C1: " + strxor(C1_ascii, key))
print("C2: " + strxor(C2_ascii, key))