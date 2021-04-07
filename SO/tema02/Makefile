build: libso.obj
	link /nologo /dll /out:so_stdio.dll libso.obj

libso.obj: libso.c
	cl /nologo /MD /W3 /D_CRT_SECURE_NO_DEPRECATE /c libso.c

clean:
	del libso.obj so_stdio.dll so_stdio.exp so_stdio.lib