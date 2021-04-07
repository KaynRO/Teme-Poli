#!/usr/bin/env python

import random
import sys

from Crypto.Cipher import AES
from utils import *

BLOCK_SIZE = AES.block_size
IV = b'This is easy HW!'


# HW - Utility function
def blockify(text, block_size=BLOCK_SIZE):
	"""
	Cuts the bytestream into equal sized blocks.

	Args:
	text should be a bytestring (i.e. b'text', bytes('text') or bytearray('text'))
	block_size should be a number

	Return:
	A list that contains bytestrings of maximum block_size bytes

	Example:
	[b'ex', b'am', b'pl', b'e'] = blockify(b'example', 2)
	[b'01000001', b'01000010'] = blockify(b'0100000101000010', 8)
	"""
	return [chunk for chunk in chunks(text, block_size)] # split into chunks and return the vector


# HW - Utility function
def validate_padding(padded_text):
	"""
	Verifies if the bytestream ends with a suffix of X times 'X' (eg. '333' or '22')

	Args:
	padded_text should be a bytestring

	Return:
	Boolean value True if the padded is correct, otherwise returns False
	"""
	
	text_len = len(padded_text)
	last_byte = padded_text[text_len - 1]

	if last_byte == 0: # if last byte is 0 then it makes no sense, there must be a padding
		return False

	if last_byte > BLOCK_SIZE: # the padding must be <= BLOCK_SIZE according to definition
		return False

	for byte in range(1, last_byte + 1): # check for every i-th byte from the end to be equal to the last one
		if padded_text[-byte] != last_byte:
			return False

	return True


# HW - Utility function
def pkcs7_pad(text, block_size=BLOCK_SIZE):
	"""
	Appends padding (X times 'X') at the end of a text.
	X depends on the size of the text.
	All texts should be padded, no matter their size!

	Args:
	text should be a bytestring

	Return:
	The bytestring with padding
	"""
 
	X = BLOCK_SIZE - int(len(text) % block_size) # calculate the padding value
	return text + bytes([X]) * X # return text + padding


# HW - Utility function
def pkcs7_depad(text):
	"""
	Removes the padding of a text (only if it's valid).
	Tip: use validate_padding

	Args:
	text should be a bytestring

	Return:
	The bytestring without the padding or None if invalid
	"""

	if not validate_padding(text): # check if text is padded
		return None

	last_byte = text[-1]
	text = text[:-last_byte] # remove last X bytes where X is the value of the last byte

	return text

def aes_dec_cbc(k, c, iv):
	"""
	Decrypt a ciphertext c with a key k in CBC mode using AES as follows:
	m = AES(k, c)

	Args:
	c should be a bytestring (i.e. a sequence of characters such as 'Hello...' or '\x02\x04...')
	k should be a bytestring of length exactly 16 bytes.
	iv should be a bytestring of length exactly 16 bytes.

	Return:
	The bytestring message m
	"""
	aes = AES.new(k, AES.MODE_CBC, iv)
	m = aes.decrypt(c)
	depad_m = pkcs7_depad(m)

	return depad_m


def aes_enc_cbc(c):

	k = b'za best key ever'
	aes = AES.new(k, AES.MODE_CBC, IV)
	m = aes.encrypt(c)

	return m

def check_cbcpad(c, iv):
	"""
	Oracle for checking if a given ciphertext has correct CBC-padding.
	That is, it checks that the last n bytes all have the value n.

	Args:
	c is the ciphertext to be checked.
	iv is the initialization vector for the ciphertext.
	Note: the key is supposed to be known just by the oracle.

	Return 1 if the pad is correct, 0 otherwise.
	"""

	key = b'za best key ever'

	if aes_dec_cbc(key, c, iv) != None:
		return 1

	return 0

if __name__ == "__main__":
	ctext = "918073498F88237C1DC7697ED381466719A2449EE48C83EABD5B944589ED66B77AC9FBD9EF98EEEDDD62F6B1B8F05A468E269F9C314C3ACBD8CC56D7C76AADE8484A1AE8FE0248465B9018D395D3846C36A4515B2277B1796F22B7F5B1FBE23EC1C342B9FD08F1A16F242A9AB1CD2DE51C32AC4F94FA1106562AE91A98B4480FDBFAA208E36678D7B5943C80DD0D78C755CC2C4D7408F14E4A32A3C4B61180084EAF0F8ECD5E08B3B9C5D6E952FF26E8A0499E1301D381C2B4C452FBEF5A85018F158949CC800E151AECCED07BC6C72EE084E00F38C64D989942423D959D953EA50FBA949B4F57D7A89EFFFE640620D626D6F531E0C48FAFC3CEF6C3BC4A98963579BACC3BD94AED62BF5318AB9453C7BAA5AC912183F374643DC7A5DFE3DBFCD9C6B61FD5FDF7FF91E421E9E6D9F633"
	ciphertext = bytes.fromhex(ctext)

	ptx = [0] * BLOCK_SIZE
	ctx = [0] * BLOCK_SIZE
	msg = []

	# TODO: implement the CBC-padding attack to find the message corresponding to the above ciphertext
	# Note: you cannot use the key known by the oracle
	# You can use the known IV in order to recover the full message

	blocks = [IV] + blockify(ciphertext)

	for current_block in range(len(blocks) - 1): # for each block of the plaintext
		for pos in range(1, BLOCK_SIZE + 1): # for each byte of the block, starting from the right
			for byte in range(256): # for every possible byte value
				ctx[-pos] = byte
				if check_cbcpad(bytes(ctx) + blocks[current_block + 1], IV): # if the oracle likes this byte
					ptx[-pos] = byte ^ pos ^ blocks[current_block][-pos] # we can calculate the corresponding byte from the plaintext
					break

			for i in range(1, pos + 1): # update all bytes from the current cyphertext block
				ctx[-i] = ptx[-i] ^ pos + 1 ^ blocks[current_block][-i]

		msg += [chr(val) for val in ptx if val > BLOCK_SIZE] # add curent plaintext block to our message (remove padding)

	msg = msg
	msg = ''.join(msg)
	print(msg)
