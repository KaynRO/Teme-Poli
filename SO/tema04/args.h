#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct args {
	unsigned short priority;
	sem_t *shared_sem;
	sem_t *semafor_child;
	so_handler *handler;
	char nume_semafor[50];
} Args;
