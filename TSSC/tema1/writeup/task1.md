## Task1 - Crypto

### Understanding the encryption algorithm
We start by looking at how the files were encrypted. According to the **cryptolocker.py**, the data was encrypted using the **XOR** function between the plaintext data and a generated *keystream*. The keystream is built upon the *key*, provided as the parameter for the script, and the length of the text

```python
def decrypt(data, key):
	return bytes([(data[idx] ^ k) for idx, k in enumerate(keystream(key, len(data)))])
```

This encryption schema is as weak as the **keystream** function due to the fact that, by knowing partial values of the keystream, we can partially recover the original text.
What the *keystream* function does is the followings:
- the first X bytes of the keystream is obtained by XOR-ing 67 with each character of the key, where X is the key length
- the rest of the bytes, from X to data length, are obtained through a formula
	```python
	k = result[i - len(key)] ^ key[i % len(key)]
	```
- the resulting stream is returned

If we start typing by hand how the *keystream* would look like for a key of length 3, we find the following pattern.
```python
result[0] = 67 ^ key[0]
result[1] = 67 ^ key[1]
result[2] = 67 ^ key[2]
result[3] = result[3 - 3] ^ key[3 % 3] = result[0] ^ key[0] = 67 ^ key[0] ^ key[0] = 67
result[4] = result[4 - 3] ^ key[4 % 3] = result[1] ^ key[0] = 67 ^ key[1] ^ key[1] = 67
result[5] = result[5 - 3] ^ key[5 % 3] = result[2] ^ key[0] = 67 ^ key[2] ^ key[2] = 67
result[6] = result[6 - 3] ^ key[6 % 3] = result[3] ^ key[0] = 67 ^ key[0] = result[0]
...snip...
```

We can clearly see that the *keystream* repeteas after 6 values which is 2 * key_length. Moreover, after each block of key length, the next block consists of the value 67. To sum up, if each block is of size key_length then:
```python
block[0] = [i ^ 67 for i in key]
block[1] = [67] * key_length
block[2] = block[0]
block[3] = block[1]
...snip...
block[2 * i] = block[0]
block[2 * (i + 1)] = block[1]
```

These being said, without knowing the key, we can recover half of the original text by simply XOR-ing the encrypted text with the output of the *keystream* function for any provided key.


### Finding the key length
Using the previous observations it is clear that, if we have the correct key length, half of the original text can be retrieved. Otherwise, the output could make no sense. Let's quickly generate all possible key length and apply the encryption algorithm again on the encrypted files. We can write a simply python script that automates this process and saves each output in a new file.
```python
import sys
import binascii
import itertools
import string
from cryptolocker import keystream, encrypt


KEY_MIN_LEN = 7
KEY_MAX_LEN = 12


def chunks(lst, n):
	for i in range(0, len(lst), n):
		yield lst[i:i + n]


def main():
	global keystream, key
	data = open(TEXTFILE_1, 'rb').read()

	for key_len in range(KEY_MIN_LEN, KEY_MAX_LEN):
		key = b'\x00' * key_len
		decrypted = encrypt(data, key)
		chk = [i.decode() for i in chunks(decrypted, key_len)]
		with open(str(key_len) + '.txt', 'w') as f:
			f.write('\n'.join(chk))


if __name__ == '__main__':
	main()
```

This gives the following files

key length of 7:
```text
sarind,
teptind
TOG>)
X
t singu
a duce-

Spre l
le lacu
Dormeau
sicriel
umb,
Sp
g{4sf0n
Hx5S1Pv
je37ZD}
ri de p
 funera
int --

ngur in
.. si e
...snip...
Si flo
lumb si
r vestm
Stam si
 cavou.
ra vint
scirtii
anele d
.

Dorm
rs amor
de plum
ori de 
si-am i
sa-l st
```

key length of 8:
```text
tindTOG>
)
Xt sin
[a duce-
Tn<Dorme
Eje37ZD}
_ngur in
Re plumb
Dt... si
_uma toa
U s-ascu
Wra de s
Tii, dom
 dogi TO
[urit ..
Flumb si
Z
X cavo
Sra vint
Yrs amor
```

key length of 9:
```text
dTOG>)
Xt
<DormeauZ
_ngur inZ

B...
Si 
_nceput 	
U s-ascu
e drumA1
[urit ..T
 cavou.TO
intTOG>)
	T.

Dorm
```

key length of 10:
```text
EteptindTO
G>)
Xt sin
Eje37ZD}p2
 dogi TOG>
[urit ..Tk
cavou.TOIG
```

key length of 11:
```text
eptindTOG>)
Tn<DormeauZ
G>p0Wraie p
I<
```

Therefore, the key length is definetly 7.


### Finding the key
At this point, what we have to do is to guess parts of the original text based on the recovered pieces. For example, if we recovered the text 'This is the:', we can assume that the next word would be 'flag' and thus we can recover 4 bytes of the key by XOR-ing each character of the word 'flag' with 67 and then with the corresponding bytes from the encrypted message. To sum up, if we can guess 7 consecutive characters that would follow one of the recovered lines, we can successfully compute the key.

Upon looking at the recovered text and Googling some of the words we find that they match a Romanian [poem](http://www.romanianvoice.com/poezii/poezii/plumb.php) named *Plumb* and written by *George Bacovia*. We grab the last 2 lines and find it's missing part:
```text
si-am i
sa-l st
```

It should be straightforward to see that the missing part is
```text
nceput(space)
```

We can write a simple python function that splits the encrypted message into chunks of length key_length and then, splits them into odd and even blocks. From the even blocks, we take the last one and XOR it with the missing word 'nceput ' and then XOR again with 67. This should result in the key used for the encryption
```python
def find_key():
	data = open(TEXTFILE_1, 'rb').read()

	chk = [i for i in chunks(data, key_len)]
	chk_even = [chk[i * 2] for i in range(len(chk) // 2)]
	last_chk = chk_even[-1:][0]

	key = xor(xor(last_chk, b'nceput '), bytes([67]))
	return key
```

```bash
┌─[kayn@parrot]─[~/Documents/ISC/task1]
└──╼ $python3 decrypt.py
b'zai4zd6'
```


### Getting the flag
Using **zai4zd6** as the key, we can finally decrypt both txt files

```python
def main():
	key = find_key()
	data1 = open(TEXTFILE_1, 'rb').read()
	data2 = open(TEXTFILE_2, 'rb').read()

	print(encrypt(data1, key).decode())
	print(encrypt(data2, key).decode())
```

```text
┌─[kayn@parrot]─[~/Documents/ISC/task1]
└──╼ $python3 decrypt.py
Tot tresarind, tot asteptind...
Sint singur, si ma duce-un gand
Spre locuintele lacustre.

Dormeau adanc sicriele de plumb,
SpeishFlag{4sf0nCYr7gasHx5S1Pv8CB7Kksje37ZD}
Si flori de plumb si funerar vestmint --
Stam singur in cavou... si era vint...
Si scirtiiau coroanele de plumb.

Dormea intors amorul meu de plumb
Pe flori de plumb, si-am inceput sa-l strig --
Stam singur langa mort... si era frig...
Si-i atirnau aripile de plumb.

Buciuma toamna
Agonic -- din fund --
Trec pasarele
Si tainic s-ascund.

Taraie ploaia ...
Nu-i nimeni pe drum;Pe-afara de stai
Te-nabusi de fum.

Departe, pe camp,
Cad corbii, domol;
Si ragete lungi
Ornesc din ocol.

Talangile, trist,
Tot suna dogi ...
Si tare-i tarziu,
Si n-am mai murit ...

Dormeau adanc sicriele de plumb,
Si flori de plumb si funerar vestmint --
Stam singur in cavou... si era vint...
Si scirtiiau coroanele de plumb.

Dormea intors amorul meu de plumb
Pe flori de plumb, si-am inceput sa-l strig --

Si tin loc de amintiri despre tine
Si ii pun pe perna ta si ma minte inima
Doar pe tine...

Prin lume ratacesc cu stelele vorbesc
Unde ejti oare?
Si nimeni nu va jtii ce mult noi ne-am iubit
Si cat ma doare...

Prin lume ratacesc cu stelele vorbesc
Unde ejti oare?
Si nimeni nu va jtii ce mult noi ne-am iubit
Si cat ma doare...

N'ai venit nici azi
Si cat de mult te-am astept
In sufletel am doar necaz iar tu de mine ai uitat.

Am luat 7 trandafiri
Si tin loc de amintiri despre tine

Iar am pus-o, iar am pus-o,
Va dau clasa si v-am spus-o,
Iar am pus-o si am s-o pun,
Ca sa ma stiti de jupan.

Multa lume cand ma vede,
Cum fac banii nu ma crede,
SpeishFlag{4sf0nCYr7gasHx5S1Pv8CB7Kksje37ZD}
Zice ca e vreo smecherie,
Sau vreun tun la loterie.

Iar am pus-o, iar am pus-o,
Va dau clasa si v-am spus-o,
Iar am pus-o si am s-o pun,
Ca sa ma stiti de jupan.

Multi au incercat cu mine,
Dar la toti la toti le-am dat rusine,
Au vazut cu ochi lor,
Cine-i seful banilor.

┌─[kayn@parrot]─[~/Documents/ISC/task1]
```


### POC Code
```python
#!/usr/bin/env python3

import sys
import binascii
import itertools
import string
from cryptolocker import keystream, encrypt

TEXTFILE_1 = 'plmb.txt.bin'
TEXTFILE_2 = 'flrns.txt.bin'

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
	last_chk = chk_even[-1:][0]

	key = xor(xor(last_chk, b'nceput '), bytes([67]))
	return key


def main():
	key = find_key()
	data1 = open(TEXTFILE_1, 'rb').read()
	data2 = open(TEXTFILE_2, 'rb').read()

	print(encrypt(data1, key).decode())
	print(encrypt(data2, key).decode())


if __name__ == '__main__':
	main()
```

### Flag
**SpeishFlag{4sf0nCYr7gasHx5S1Pv8CB7Kksje37ZD}**