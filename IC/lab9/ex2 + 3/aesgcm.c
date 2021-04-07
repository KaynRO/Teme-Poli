#include <openssl/evp.h>
#include <openssl/err.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

void hexdump(unsigned char * string, int length) {
    int i;
    for (i = 0; i < length; i++) {
        printf("%02x", string[i]);
    }
}

unsigned char *tag;

void aes_gcm_encrypt(unsigned char * ptext,
        int plen,
        unsigned char * key,
        unsigned char * iv,
        unsigned char ** ctext,
        int * clen) {

     EVP_CIPHER_CTX *ctx;

    int len;

    /* Create and initialise the context */
    if(!(ctx = EVP_CIPHER_CTX_new()))
        return;

    /* Initialise the encryption operation. */
    if(1 != EVP_EncryptInit_ex(ctx, EVP_aes_256_gcm(), NULL, NULL, NULL))
        return;

    /* Initialise key and IV */
    if(1 != EVP_EncryptInit_ex(ctx, NULL, NULL, key, iv))
        return;

    /*
     * Provide the message to be encrypted, and obtain the encrypted output.
     * EVP_EncryptUpdate can be called multiple times if necessary
     */
    if(1 != EVP_EncryptUpdate(ctx, *ctext, &len, ptext, plen))
        return;
    *clen = len;

    /*
     * Finalise the encryption. Normally ciphertext bytes may be written at
     * this stage, but this does not occur in GCM mode
     */
    if(1 != EVP_EncryptFinal_ex(ctx, *ctext + len, &len))
        return;
    *clen += len;

    /* Get the tag */
    if(1 != EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_GET_TAG, 16, tag))
        return;
    hexdump(tag, 16);
    printf("\n");

    /* Clean up */
    EVP_CIPHER_CTX_free(ctx);
}

void aes_gcm_decrypt(unsigned char *ctext, int clen,
                unsigned char *key,
                unsigned char *iv,
                unsigned char **ptext, int *plen)
{
    EVP_CIPHER_CTX *ctx;
    int len;
    int ret;

    /* Create and initialise the context */
    if(!(ctx = EVP_CIPHER_CTX_new()))
        return;

    /* Initialise the decryption operation. */
    if(!EVP_DecryptInit_ex(ctx, EVP_aes_256_gcm(), NULL, NULL, NULL))
        return;

    /* Initialise key and IV */
    if(!EVP_DecryptInit_ex(ctx, NULL, NULL, key, iv))
        return;

    /*
     * Provide the message to be decrypted, and obtain the plaintext output.
     * EVP_DecryptUpdate can be called multiple times if necessary
     */
    if(!EVP_DecryptUpdate(ctx, *ptext, &len, ctext, clen))
        return;
    *plen = len;

    /* Set expected tag value. Works in OpenSSL 1.0.1d and later */
    if(!EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_TAG, 16, tag))
        return;

    /*
     * Finalise the decryption. A positive return value indicates success,
     * anything else is a failure - the plaintext is not trustworthy.
     */
    ret = EVP_DecryptFinal_ex(ctx, *ptext + len, &len);

    /* Clean up */
    EVP_CIPHER_CTX_free(ctx);

    if(ret > 0)
        *plen += len; 
    else
        *plen = -1;
}

int main(int argc, char * argv[]) {
    ERR_load_crypto_strings();
    tag = (unsigned char*) malloc(16 * sizeof(unsigned char));

    unsigned char key[] = "0123456789abcdef0123456789abcdef"; /* 256-bit key */
    unsigned char iv[] = "0123456789ab";                      /* 96-bit IV   */

    unsigned char * ptext = (unsigned char *)"Hello, SSLWorld!";
    int plen = strlen((const char *)ptext);

    unsigned char * ctext = (unsigned char *) malloc(32 * sizeof(char));
    int clen;

    printf("Plaintext = %s\n", ptext);
    printf("Plaintext  (hex) = "); hexdump(ptext, plen); printf("\n");

    aes_gcm_encrypt(ptext, plen, key, iv, &ctext, &clen);
    printf("Ciphertext (hex) = "); hexdump(ctext, clen); printf("\n");

    unsigned char * ptext2 = (unsigned char *) malloc(16 * sizeof(char));
    int plen2;
    aes_gcm_decrypt(ctext, clen, key, iv, &ptext2, &plen2);
    printf("Done decrypting!\n");

    ptext2[plen2] = '\0';
    printf("Plaintext = %s\n", ptext2);

    if (memcmp(ptext, ptext2, strlen((const char *)ptext)) == 0) {
        printf("Ok!\n");
    } else {
        printf("Not ok :(\n");
    }

    return 0;
}
