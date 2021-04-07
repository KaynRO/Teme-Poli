#!/bin/sh

openssl enc -aes-256-cbc -d -in aesgcm.c.enc -out aesgcm.c -kfile password.bin 2> /dev/null
rm aesgcm.c.enc
rm password.bin
