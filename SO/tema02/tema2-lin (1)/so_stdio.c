#include "so_stdio.h"
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/wait.h>
#include <stdio.h>

SO_FILE *so_fopen(const char *pathname, const char *mode)
{
    SO_FILE *file;
    int fd = -1;

    if(strcmp(mode, "a") && strcmp(mode, "r") && strcmp(mode, "w") &&
        strcmp(mode, "a+") && strcmp(mode, "r+") && strcmp(mode, "w+")) {
            return NULL;
        }

    if (!strcmp(mode,"a"))
        fd = open(pathname, O_WRONLY | O_APPEND | O_CREAT, 0666);
    if (!strcmp(mode,"r"))
        fd = open(pathname, O_RDONLY);
    if (!strcmp(mode,"w"))
        fd = open(pathname, O_WRONLY | O_CREAT | O_TRUNC, 0666);
    if (!strcmp(mode,"a+"))
        fd = open(pathname, O_APPEND | O_RDWR | O_CREAT, 0666);
    if (!strcmp(mode,"w+"))
        fd = open(pathname, O_RDWR | O_CREAT | O_TRUNC, 0666);
    if (!strcmp(mode,"r+"))
        fd = open(pathname, O_RDWR);


    if (fd == -1) {
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

    if (close(stream->fd) < 0) {
        free(stream->buff_base);
        free(stream);
        return SO_EOF;
    } else {
        free(stream->buff_base);
        free(stream);
        return res;
    }
}

int so_fileno(SO_FILE *stream) {
    return stream->fd;
}

int so_fflush(SO_FILE *stream) {
    int aux = stream->mode;
    if (stream->mode == _WRITE) {
        int retVal = write(stream->fd, stream->buff_base, stream->count);
        if (retVal < 0) {
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
    if (stream->mode == _WRITE) {
        so_fflush(stream);
    } else if (stream->mode == _READ) {
        stream->next = stream->buff_base;
        stream->count = 0;
    }

    int bytes = lseek(stream->fd, offset, whence);

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
    if (so_feof(stream) || so_ferror(stream))
        return 0;
    int aux = nmemb;

    while (nmemb > 0) {
        int res = so_fgetc(stream);
        if (so_feof(stream))
            return aux - nmemb;
        if (so_ferror(stream))
            return 0;
        nmemb--;
        *(char *)ptr = (char) res;
        ptr++;

    }

    return aux;
}

size_t so_fwrite(const void *ptr, size_t size, size_t nmemb, SO_FILE *stream) {
    if (so_ferror(stream))
        return 0;
    int aux = nmemb;

    while (nmemb > 0) {
        so_fputc((int)*(char *)ptr++, stream);
        if (so_ferror(stream))
            return aux - nmemb;
        nmemb--;
    }

    return aux;
}

void changeMode(SO_FILE *stream, int mode)
{
    if (stream->mode != _WRITE && mode == _WRITE) {
        stream->count = 0;
        stream->next = stream->buff_base;
        stream->mode = _WRITE;
    }

    if (stream->mode != _READ && mode == _READ) {
        if (stream->mode == _WRITE) {
            write(stream->fd, stream->buff_base, stream->count);
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
        stream->count = read(stream->fd, stream->buff_base, 4096);
        if (stream->count == 0) {
            stream->mode = _EOF;
        } else if (stream->count < 0) {
            stream->mode = _ERR;
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
        retVal = write(stream->fd, stream->buff_base, 4096);
        if(retVal < 0) {
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
    SO_FILE *stream;
    int pdes[2];
    pid_t pid;

    if (pipe(pdes) < 0) {
        return (NULL);
    }

    switch (pid = fork()) {
    	case -1:			/* Error. */
    		(void)close(pdes[0]);
    		(void)close(pdes[1]);
    		return (NULL);
    	case 0:				/* Child. */
    	    {
        		if (!strcmp(type, "r")) {
        			(void) close(pdes[0]);
        			if (pdes[1] != STDOUT_FILENO) {
        				(void)dup2(pdes[1], STDOUT_FILENO);
        				(void)close(pdes[1]);
        			}
        		} else {
        			(void)close(pdes[1]);
        			if (pdes[0] != STDIN_FILENO) {
        				(void)dup2(pdes[0], STDIN_FILENO);
        				(void)close(pdes[0]);
        			}
        		}
        		execlp("sh", "sh", "-c", command, NULL);
                return NULL;
    	    }
    }

    /* parent */
    if (!strcmp(type, "r")) {
        stream = calloc(1, sizeof(SO_FILE));
        stream->buff_base = calloc(4096, sizeof(char));
        stream->fd = pdes[0];
        stream->pid = pid;
        stream->next = stream->buff_base;
        stream->mode = _NONE;  // vezi aici
        stream->count = 0;
        stream->cursor = 0;
		(void)close(pdes[1]);
	} else {
        stream = calloc(1, sizeof(SO_FILE));
        stream->buff_base = calloc(4096, sizeof(char));
        stream->fd = pdes[1];
        stream->pid = pid;
        stream->next = stream->buff_base;
        stream->mode = _NONE;  // vezi aici
        stream->count = 0;
        stream->cursor = 0;
		(void)close(pdes[0]);
	}

    return stream;
}

int so_pclose(SO_FILE *stream) {
    int stat;
    pid_t pid;

    pid = stream->pid;
    (void) so_fclose(stream);
    while (waitpid(pid, &stat, 0) == -1) {
        if (errno != EINTR){
            stat = -1;
            break;
        }
    }
    return(stat);
}
