rm skel_size.o
rm tema3
rm tema3.o

gcc -m32 -c tema3.c
nasm -f elf32 -g skel_size.asm
gcc -m32 -o tema3 tema3.o skel_size.o

