#include "so_stdio.h"
#include <windows.h>

SO_FILE *so_fopen(const char *pathname, const char *mode)
{
    SO_FILE *file;
    HANDLE fd = -1;

    if(strcmp(mode, "a") && strcmp(mode, "r") && strcmp(mode, "w") &&
        strcmp(mode, "a+") && strcmp(mode, "r+") && strcmp(mode, "w+")) {
            return NULL;
        }

    if (!strcmp(mode,"a"))
        fd = CreateFile(pathname, FILE_APPEND_DATA | GENERIC_READ,  FILE_SHARE_WRITE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
    if (!strcmp(mode,"r"))
        fd = CreateFile(pathname, GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (!strcmp(mode,"w"))
        fd = CreateFile(pathname, GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
    if (!strcmp(mode,"a+"))
        fd = CreateFile(pathname, FILE_APPEND_DATA | GENERIC_READ,  FILE_SHARE_WRITE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
    if (!strcmp(mode,"w+"))
        fd = CreateFile(pathname, GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
    if (!strcmp(mode,"r+"))
        fd = CreateFile(pathname, GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);

    if (fd == INVALID_HANDLE_VALUE) {
        return NULL;
    }

    file = calloc(1, sizeof(SO_FILE));
    file->buff_base = calloc(4096, sizeof(char));
    if (file->buff_base == NULL)
        return NULL;             // aici rezolva asta -- ceva perror
    file->next = file->buff_base;
    file->fd = fd;
    file->mode = _NONE;  // vezi aici
    file->count = 0;
    file->cursor = 0;

    return file;
}

int so_fclose(SO_FILE *stream) {
    int res = so_fflush(stream);
    BOOL closeREs = CloseHandle(stream->fd);

    if (closeREs == FALSE) {
        free(stream->buff_base);
        free(stream);
        return SO_EOF;
    } else {
        free(stream->buff_base);
        free(stream);
        return res;
    }
}

HANDLE so_fileno(SO_FILE *stream) {
	return stream->fd;
}

int so_fflush(SO_FILE *stream) {
    int aux = stream->mode;
    int bytesWritten = 0;
    if (stream->mode == _WRITE) {
        BOOL x = WriteFile(stream->fd, stream->buff_base, stream->count, &bytesWritten, NULL);
        if (!x) {
            stream->mode = _ERR;
        } else {
            stream->mode = _NONE;
        }
    }

    stream->next = stream->buff_base;
    stream->count = 0;

    if (aux != _ERR && so_ferror(stream)) {
        return SO_EOF;
    }

    return 0;
}

int so_fseek(SO_FILE *stream, long offset, int whence) {
    DWORD bytes;
    if (stream->mode == _WRITE) {
        so_fflush(stream);
    } else if (stream->mode == _READ) {
        stream->next = stream->buff_base;
        stream->count = 0;
    }

    bytes = SetFilePointer(stream->fd, offset, NULL, whence);

    stream->cursor = bytes;

    if (bytes < 0) {
        return -1;
    } else {
        return 0;
    }
}

long so_ftell(SO_FILE *stream) {
    return stream->cursor;
}

size_t so_fread(void *ptr, size_t size, size_t nmemb, SO_FILE *stream) {
    DWORD aux;
    if (so_feof(stream) || so_ferror(stream))
       return 0;
   aux = nmemb;

   while (nmemb > 0) {
       int res = so_fgetc(stream);
       if (so_feof(stream))
           return aux - nmemb;
       if (so_ferror(stream))
           return 0;
       nmemb--;
       *(CHAR *)ptr = (CHAR) res;
       ptr = ((char *) ptr) + 1;
   }

   return aux;
}

size_t so_fwrite(const void *ptr, size_t size, size_t nmemb, SO_FILE *stream) {
    DWORD aux;
    if (so_ferror(stream))
        return 0;
    aux = nmemb;

    while (nmemb > 0) {
        so_fputc((int)*(char *)ptr, stream);
        ptr = ((char *) ptr) + 1;
        if (so_ferror(stream))
            return aux - nmemb;
        nmemb--;
    }

    return aux;
}

void changeMode(SO_FILE *stream, int mode)
{
    int bytesWritten = 0;
    if (stream->mode != _WRITE && mode == _WRITE) {
           stream->count = 0;
           stream->next = stream->buff_base;
           stream->mode = _WRITE;
    }

   if (stream->mode != _READ && mode == _READ) {
       if (stream->mode == _WRITE) {
           WriteFile(stream->fd, stream->buff_base, stream->count, &bytesWritten, NULL);
       }
       stream->count = 0;
       stream->next = stream->buff_base;
       stream->mode = _READ;
   }
}

int so_fgetc(SO_FILE *stream) {
    int value;
    changeMode(stream, _READ);
    if (stream->count == 0) {
        BOOL val = ReadFile(stream->fd, stream->buff_base, 4096, &(stream->count), NULL);
        if (!val) {
            stream->mode = _ERR;
        } else if (stream->count == 0) {
            stream->mode = _EOF;
        }

        if(stream->count <= 0)
            return SO_EOF;
    }

    stream->cursor++;
    stream->count--;
    value = (int) *(stream->next);
    if (stream->count == 0) {
        stream->next = stream->buff_base;
    } else {
        stream->next++;
    }

    return value;
}

int so_fputc(int c, SO_FILE *stream) {
    int retVal;
    changeMode(stream, _WRITE);
    if (stream->count == 4096) {
        BOOL x = WriteFile(stream->fd, stream->buff_base, 4096, &retVal, NULL);
        if(!x) {
            stream->mode = _ERR;
            return SO_EOF;
        }
        stream->count = 0;
    }

    stream->cursor++;
    stream->count++;
    *stream->next = (char)c;
    if (stream->count == 4096) {
        stream->next = stream->buff_base;
    } else {
        stream->next++;
    }

    return c;
}

int so_feof(SO_FILE *stream) {
    if (stream->mode == _EOF) {
        return _EOF;
    }

    return 0;
}

int so_ferror(SO_FILE *stream) {
    if (stream->mode == _ERR) {
        return _ERR;
    }

    return 0;
}

SO_FILE *so_popen(const char *command, const char *type) {
   return  NULL;
}

int so_pclose(SO_FILE *stream) {
	return 0;
}
