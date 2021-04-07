from format_funcs import *


def main():

    # Plaintexts
    s1 = 'floare'
    s2 = 'albina'
    G = ''  # To find

    # Obtain crc of s1
    # See this site:
    # http://www.lammertbies.nl/comm/info/crc-calculation.html
    x1 = str_2_hex(s1)
    x2 = str_2_hex(s2)
    print("x1: " + x1)
    crc1 = '8E31'  # CRC-16 of x1

    # Compute delta (xor) of x1 and x2:
    xd = hexxor(x1, x2)
    print("xd: " + xd)


if __name__ == "__main__":
    main()
