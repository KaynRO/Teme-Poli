#!/bin/sh

key=`openssl rand 16`

echo 'Laborator IC' > msg1
echo 'Laborator IC!' > msg2

openssl dgst -sha1 -hmac $key msg1
openssl dgst -sha1 -hmac $key msg2

rm msg1
rm msg2