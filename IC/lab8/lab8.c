#include <openssl/sha.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <time.h>

/* We want a collision in the first 4 bytes = 2^16 attempts */
#define N_BITS  16

int raw2int4(unsigned char * digest) {
	int i;
	int sum = 0;

	for (i = 0; i <= 3; i++) {
		sum += sum * 256 + digest[i];
	}

	return sum;
}


void hexdump(unsigned char * string, int length) {
	int i;
	for (i = 0; i < length; i++) {
		printf("%02x", string[i]);
	}
	printf("\n");
}

int main(int argc, char * argv[]) {
	uint32_t attempt = 2 << 16; 
	int i, j;
	srand(time(NULL));
	/* Iterate through 16 bits of the 32; use the rest to run different attacks */
	unsigned char md[20]; /* SHA-1 outputs 160-bit digests */
	 
	SHA_CTX context;
	SHA1_Init(&context);
	char **array1 = malloc(attempt * sizeof(char *)); // Allocate row pointers
	int **aux = (int**) malloc (attempt * sizeof(int*));

	/* Step 1. Generate 2^16 different random messages */
	for(i = 0; i < attempt; i++) {

		array1[i] = (char *) malloc(21 * sizeof(char));
		aux[i] = malloc(4 * sizeof(int));
		*aux[i] =  rand() % attempt;	
		
		/* Step 2. Compute hashes */
		SHA1_Update(&context,aux, 20);
		SHA1_Final(array1[i], &context);	
	}
	
	/* Step 3. Check if there exist two hashes that match in the first four bytes */
	for (i = 0 ; i < attempt - 1 ; i++)
	for (j = i + 1 ; j < attempt ; j++)
		if(raw2int4(array1[i]) == raw2int4(array1[j])){
			printf("Plaintexts are: %d %d\n", *aux[i], *aux[j]);
			hexdump(array1[i],20);
			hexdump(array1[j],20);
		}    

	return 0;
}