#include "stdio.h"
#include <pthread.h>
#include <semaphore.h>
#include <sys/types.h>
#include <fcntl.h>


typedef struct thread_info {
	unsigned short priority;
	int eveniment;
	sem_t *semafor;
	pthread_t thread_id;
	int cuanta;
	char nume_semafor[50];
} T_info;
