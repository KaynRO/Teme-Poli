#include <stdlib.h>
#include "PriorityQueue.h"


T_info *create_T_info(short priority)
{
	T_info *x;

	x = malloc(sizeof(T_info));

	if (x == NULL)
		return x;

	x->priority = priority;

	return x;
}

PQueue *init()
{
	PQueue *queue;

	queue = (PQueue *)malloc(sizeof(PQueue));
	queue->curr_position = 0;
	queue->size = 0;
	return queue;
}


int thread_compare(T_info t1, T_info t2)
{
	return t1.priority - t2.priority;
}

void show(PQueue *queue)
{
	int i;

	for (i = 0; i < queue->curr_position; i++) {
		//printf("id : %llu", queue->arr[i].thread_id);
		//printf("si priority = %d\n", queue->arr[i].priority);
	}
	printf("\n");
}

int propaga_sus(PQueue *queue)
{
	int curr;
	T_info aux;
	//daca nu avem nimic in arr sau avem doar un sg element
	if (queue->curr_position == 0 || queue->curr_position == 1)
		return 1;

	curr = queue->curr_position - 1;
	//cat timp parintele nodului mai mic e mai mic ca nodul curent
	while (curr > 0 && thread_compare(queue->arr[curr],
		queue->arr[(curr - 1) / 2]) > 0) {

		aux = queue->arr[curr];
		queue->arr[curr] = queue->arr[(curr - 1) / 2];
		queue->arr[(curr - 1) / 2] = aux;
		curr = (curr - 1) / 2;
	}

	return 0;
}

int propaga_jos(PQueue *queue)
{
	int curr;
	int left_pos;
	int right_pos;
	T_info aux;
	//daca nu avem nimic in arr sau avem doar un sg element
	if (queue->curr_position == 0 || queue->curr_position == 1)
		return 0;

	curr = 0;

	while (curr < queue->curr_position) {
		left_pos = -1;
		right_pos = -1;
		if (curr * 2 + 1 < queue->curr_position &&
			thread_compare(queue->arr[curr],
				queue->arr[curr * 2 + 1]) < 0)
			left_pos = curr * 2 + 1;

		if (curr * 2 + 2 < queue->curr_position &&
			thread_compare(queue->arr[curr],
				queue->arr[curr * 2 + 2]) < 0)
			right_pos = curr * 2 + 2;

		//a ajuns la pozitia buna
		if (right_pos < 0 && left_pos < 0)
			return 0;

		if (left_pos > 0 && right_pos < 0) {
			aux = queue->arr[left_pos];
			queue->arr[left_pos] = queue->arr[curr];
			queue->arr[curr] = aux;
			curr = left_pos;
		}

		if (left_pos < 0 && right_pos > 0) {
			aux = queue->arr[right_pos];
			queue->arr[right_pos] = queue->arr[curr];
			queue->arr[curr] = aux;
			curr = right_pos;
		}

		if (left_pos > 0 && right_pos > 0) {
			int pos;

			if (thread_compare(queue->arr[left_pos],
				queue->arr[right_pos]) > 0)
				pos = left_pos;
			else
				pos = right_pos;

			aux = queue->arr[pos];
			queue->arr[pos] = queue->arr[curr];
			queue->arr[curr] = aux;
			curr = pos;
		}
	}

	return 0;
}

int add(PQueue *queue, T_info *t_info)
{	//daca nu avem loc in arr dublam spatiul arr
	if (queue->size == 0) {
		queue->size = 1;
		queue->arr = (T_info *)malloc(queue->size * sizeof(T_info));
	}

	if (queue->size <= queue->curr_position) {
		T_info *aux;

		aux = malloc(2 * queue->size * sizeof(T_info));

		if (aux == NULL)
			return ERROR;

		memcpy(aux, queue->arr, queue->size * sizeof(T_info));
		free(queue->arr);
		queue->arr = aux;
		aux = NULL;
		queue->size = queue->size * 2;
	}

	queue->arr[queue->curr_position++] = *t_info;
	//printf("curr_position = %d , da\n",queue->curr_position);
	return propaga_sus(queue);
}

int pop(PQueue *queue, T_info *t_info)
{
	if (queue->size <= 0 || queue->curr_position <= 0)
		return ERROR;

	*t_info = queue->arr[0];
	queue->arr[0] = queue->arr[--queue->curr_position];

	if (queue->curr_position > 0)
		return propaga_jos(queue);
	else
		return 0;
}


int add_threads(PQueue *threads, T_info *t_info)
{
	if (threads->size == 0) {
		threads->size = 1;
		threads->curr_position = 0;
		threads->arr = malloc(threads->size * sizeof(T_info));
	}

	if (threads->size <= threads->curr_position) {
		T_info *aux;

		aux = (T_info *)malloc(2 * threads->size * sizeof(T_info));
		memcpy(aux, threads->arr, threads->size * sizeof(T_info));
		free(threads->arr);
		threads->arr = aux;
		threads->size = threads->size * 2;
	}

	memcpy(&threads->arr[threads->curr_position++], t_info, sizeof(T_info));
	return 0;
}

int delete_threads(PQueue *threads, T_info *t_info)
{
	int i, j;

	for (i = 0; i < threads->curr_position; i++) {
		if (memcmp(threads->arr + i, t_info, sizeof(T_info)) == 0) {
			for (j = i; j < threads->curr_position - 1; j++)
				threads->arr[j] = threads->arr[j + 1];
			threads->curr_position--;
			return FOUND;
		}
	}

	return NOT_FOUND;
}

void free_queue(PQueue **queue)
{
	if (queue == NULL || *queue == NULL)
		return;
	PQueue *aux;

	aux = *queue;
	free(aux->arr);
	free(aux);
}
