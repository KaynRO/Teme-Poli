#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <pthread.h>
#include "thread_info.h"
#define ERROR -1
#define FOUND 1
#define NOT_FOUND -2


typedef struct pQueue{
	T_info *arr;
	int curr_position;
	int size;
}PQueue;

//--------------------------------------------------------

int add_threads(PQueue *threads, T_info *t_info);

int delete_threads(PQueue *threads, T_info *t_info);


//--------------------------------------------------------

T_info *create_T_info(short priority);

PQueue *init();

int add(PQueue *queue, T_info *t_info);

int pop(PQueue *queue, T_info *t_info);

int propaga_sus(PQueue *queue);

int propaga_jos(PQueue *queue);

int thread_compare(T_info t1, T_info t2);

void free_queue(PQueue **queue);

void show(PQueue *queue);
