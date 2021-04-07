from utils import *
from operator import itemgetter
import bisect
from Crypto.Cipher import DES


def get_index(a, x):
	i = bisect.bisect_left(a, x)
	if i != len(a) and a[i] == x:
		return i
	else:
		return -1


def des_enc(k, m):
	d = DES.new(k, DES.MODE_ECB)
	c = d.encrypt(m)
	return c


def des_dec(k, c):

	d = DES.new(k, DES.MODE_ECB)
	m = d.decrypt(c)
	return m


def des2_enc(k1, k2, m):
	c1 = des_enc(k2, m)
	c2 = des_enc(k1, c1)

	return c2


def des2_dec(k1, k2, c):
	c1 = des_dec(k1, c)
	m = des_dec(k2, c1)

	return m

def main():
	# Exercitiu pentru test des2_enc
	key1 = 'Smerenie'
	key2 = 'Dragoste'
	m1_given = 'Fericiti cei saraci cu duhul, ca'
	c1 = 'cda98e4b247612e5b088a803b4277710f106beccf3d020ffcc577ddd889e2f32'
	c2 = '54826ea0937a2c34d47f4595f3844445520c0995331e5d492f55abcf9d8dfadf'

	# TODO: implement des2_enc and des2_dec
	m1 = des2_dec(key1.encode(), key2.encode(), bytes.fromhex(c1)).decode()
	m2 = des2_dec(key1.encode(), key2.encode(), bytes.fromhex(c2)).decode()
	
	print('ciphertext1: ' + c1)
	print('plaintext1: ' + m1)
	print('plaintext1 in hexa: ' + str_2_hex(m1))

	print('ciphertext2: ' + c2)
	print('plaintext2: ' + m2)
	print('plaintext2 in hexa: ' + str_2_hex(m2))
	
	# TODO: run meet-in-the-middle attack for the following plaintext/ciphertext
	m1 = 'Pocainta'
	c1 = '9f98dbd6fe5f785d' # in hex string
	m2 = 'Iertarea'
	c2 = '6e266642ef3069c2'
	
	# Note: you only need to search for the first 2 bytes of the each key:
	k1_partial = 'oIkvH5'
	k2_partial = 'GK4EoU'

	tbs = {}
	case1 = set()
	case2 = set()

	#Create table for each possible value of k2
	for b1 in range(0, 128, 2):
		for b2 in range(0, 128, 2):
			k2_complete = chr(b1) + chr(b2) + k2_partial
			tbs[des_enc(k2_complete.encode(), m1.encode())] = k2_complete

	for b1 in range(0, 128, 2):
		for b2 in range(0, 128, 2):
			k1_complete = chr(b1) + chr(b2) + k1_partial
			dec_m = des_dec(k1_complete.encode(), bytes.fromhex(c1))

			if dec_m in tbs.keys():
				case1.add((tbs[dec_m], k1_complete))

	
	for b1 in range(0, 128, 2):
		for b2 in range(0, 128, 2):
			k2_complete = chr(b1) + chr(b2) + k2_partial
			tbs[des_enc(k2_complete.encode(), m2.encode())] = k2_complete

	for b1 in range(0, 128, 2):
		for b2 in range(0, 128, 2):
			k1_complete = chr(b1) + chr(b2) + k1_partial
			dec_m = des_dec(k1_complete.encode(), bytes.fromhex(c2))

			if dec_m in tbs.keys():
				case2.add((tbs[dec_m], k1_complete))

	print(case1.intersection(case2))


if __name__ == "__main__":
	main()

