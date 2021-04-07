# Try to decrypt some secret numbers encrypted using the decryption you just implemented.

# The parameters are the same except that I changed the secret key s. :D
# Of course you need the secret key in order to decrypt the numbers but I won't tell it to you because is secret (s=17).
from ex2_a import *


def conv_binary(nr):
	s = 0
	for i in range(len(nr)):
		s += nr[i] * (2 ** (len(nr) - i - 1))

	return s


secretnumber1 = [(57, 11), (91, 13), (38, 29), (68, 55)]
secretnumber2 = [(35, 22), (9, 67), (91, 10), (50, 89)]
secretnumber3 = [(51, 52), (51, 8), (76, 90), (90, 89)]
secretnumber4 = [(68, 50), (18, 28), (93, 43), (61, 77)]
secretnumber5 = [(33, 39), (68, 6), (17, 57), (53, 90)]


# Does [number1, number2, number3, number4, number5] make sense? Maybe in hexadecimal ??
s = 17
q = 97
numbers = []
secrets = [secretnumber1, secretnumber2, secretnumber3, secretnumber4, secretnumber5]
for i in secrets:
	numbers.append(conv_binary(decrypt(i, s, q)))

print(numbers)