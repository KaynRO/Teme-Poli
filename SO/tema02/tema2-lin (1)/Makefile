build: so_stdio.so

so_stdio.o: so_stdio.h so_stdio.c
	gcc -fPIC -c so_stdio.c

so_stdio.so: so_stdio.o
	gcc -shared so_stdio.o -o libso_stdio.so

clean:
	rm *.o *.so
