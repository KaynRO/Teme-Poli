#!/usr/bin/env python3

import sys
import binascii
import itertools
import string
from cryptolocker import keystream, encrypt

TEXTFILE_1 = 'nparaschiv/task1/plmb.txt.bin'
TEXTFILE_2 = 'nparaschiv/task1/flrns.txt.bin'

key_len = 7


def chunks(lst, n):
	for i in range(0, len(lst), n):
		yield lst[i:i + n]

def xor(a, b):
	return bytes([a[i % len(a)] ^ b[i % len(b)] for i in range(max(len(a), len(b)))])


def find_key():
	data = open(TEXTFILE_1, 'rb').read()

	chk = [i for i in chunks(data, key_len)]
	chk_even = [chk[i * 2] for i in range(len(chk) // 2)]
	chk_odd = [chk[i * 2 + 1] for i in range(len(chk) // 2)]
	last_chk = chk_even[-2:][0]

	key = xor(xor(last_chk, b'plumb.\x0a'), bytes([67]))
	return key


def main():
	key = find_key()
	print(key)
	data1 = open(TEXTFILE_1, 'rb').read()
	data2 = open(TEXTFILE_2, 'rb').read()

	print(encrypt(data1, key).decode())
	print(encrypt(data2, key).decode())


if __name__ == '__main__':
	main()