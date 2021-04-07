from caesar import *


def decrypt(ciphertext):
    for key in range(28):
        plaintext = ''
        for char in ciphertext:
            value = chr(ord(char) - key)
            if ord(value) < 65:
                value = chr(90 - (65 - ord(value)) + 1)
            plaintext +=value

        if "YOU" in plaintext:
            print("[+] Found valid key, " + str(key))
            return plaintext
        if "THE" in plaintext:
            print("[+] Found valid key, " + str(key))
            return plaintext

def main():
    ciphertexts = []
    with open("msg_ex1.txt", 'r') as f:
        for line in f.readlines():
            ciphertexts.append(line[:-1])

    for c in ciphertexts:
        print(decrypt(c))


if __name__ == "__main__":
    main()
