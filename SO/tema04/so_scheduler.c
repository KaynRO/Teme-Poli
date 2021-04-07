#include "so_scheduler.h"
#include "PriorityQueue.h"
#include "args.h"
#include "utils.h"

#include <sys/types.h>
#include <semaphore.h>
#include <unistd.h>
#include <pthread.h>

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define ERROR_MALLOC -3
#define NO_EVENT -10
#define UNINITALIZED_THREAD 4294967295
#define MAX 4294967295

PQueue *queue_ready;
PQueue *queue_blocked;
PQueue *threads;

char start = 1;

T_info *curr_thread;

unsigned int no_io = MAX;
unsigned int time_quant = MAX;

pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;


void *function(void *args)
{

	//printf("[function] intrare\n");
	int res;

	Args *info_args;
	T_info *t_info;

	info_args = (Args *)args;
	t_info = malloc(sizeof(T_info));

	strcpy(t_info->nume_semafor, info_args->nume_semafor);
	t_info->priority = info_args->priority;
	t_info->eveniment = NO_EVENT;
	t_info->semafor = info_args->semafor_child;
	t_info->thread_id = pthread_self();
	t_info->cuanta = -1;

	pthread_mutex_lock(&lock);
	add(queue_ready, t_info);
	add_threads(threads, t_info);
	//este cazul primului thread
	if (curr_thread->thread_id == UNINITALIZED_THREAD) {
		pop(queue_ready, curr_thread);
		curr_thread->cuanta = time_quant;
		//anunta pe cel care a facut fork ca am adaugat in coada
		sem_post(info_args->shared_sem);
		pthread_mutex_unlock(&lock);

	} else {
		//anunta pe cel care a facut fork ca am adaugat in coada
		sem_post(info_args->shared_sem);
		pthread_mutex_unlock(&lock);
		//printf("[function] %llu astept la semaforul
		// de dinainte de handler\n",t_info->thread_id);

		//blocheaza noul thread
		sem_wait(t_info->semafor);
		//printf("[function] am trecut de semafor\n");
	}

	//printf("[function] th_id = %llu am apelat handler si
	//inca nu am trecut de el\n",curr_thread->thread_id);
	info_args->handler(info_args->priority);
	//printf("[function]current_thread = %llu am trecut
	//	de handler\n",curr_thread->thread_id);

	pthread_mutex_lock(&lock);

	//daca am ajuns aici inseamna ca am terminat tot ce aveam
	//de executat in current thread deci distrugem semaforul asociat
	//acestui thread
	res = sem_close(curr_thread->semafor);
	DIE(res == -1, "eroare la sem_close curr_thread");

	res = sem_unlink(curr_thread->nume_semafor);
	DIE(res == -1, "eroare la sem_unlink curr_thread\n");

	//obtine threadul cu prioritatea maxima din queue_ready
	res = pop(queue_ready, curr_thread);
	//daca am obtinut un element din coada
	if (res == 0) {
		curr_thread->cuanta = time_quant;
		//dam drumul acestui thread
		sem_post(curr_thread->semafor);
	//altfel inseamna ca nu avem elemente in coada, deci resetam la NULL
	} else {
		if (curr_thread != NULL)
			free(curr_thread);
		curr_thread = NULL;
	}

	pthread_mutex_unlock(&lock);

	//printf("[function] iesire\n");
	return (void *)NULL;
}


void check_ROUND_ROBIN(void)
{
	//printf("[check_ROUND_ROBIN] intrare\n");
	T_info *aux;
	sem_t *sem_curr;
	sem_t *sem_new;

	aux = malloc(sizeof(T_info));

	pthread_mutex_lock(&lock);

	//daca coada de prioritati este goala
	if (queue_ready != NULL && queue_ready->curr_position < 1) {
		free(aux);
		//daca cuanta threadului current e 1, inseamna ca la sfarsitul
		//acestui apel de functie va fi 0 si cum nu avem alt thread de
		//schimbat, refacem cuanta threadului curent
		if (curr_thread->cuanta == 1)
			curr_thread->cuanta = time_quant;
		else
			curr_thread->cuanta--;

		pthread_mutex_unlock(&lock);
	//daca acum expira cuanta (cuanta e 1)
	} else if (curr_thread->cuanta == 1) {
		curr_thread->cuanta = 0;
		//extragem in aux elementul cu prioritate maxima din queue
		pop(queue_ready, aux);

		//daca elementul extras din coada are prioritatea mai mica
		//ca a celui curent il adaug inapoi si refac cuanta threadului
		//curent
		if (aux->priority < curr_thread->priority) {
			add(queue_ready, aux);
			free(aux);
			curr_thread->cuanta = time_quant;
			pthread_mutex_unlock(&lock);
		} else {
			//adaug curr_thread la coada de ready
			add(queue_ready, curr_thread);

			//refacem cuanta maxima pentru threadul extras
			aux->cuanta = time_quant;

			sem_curr = curr_thread->semafor;
			sem_new = aux->semafor;

			curr_thread = aux;
			//dam drumul la nou thread
			sem_post(sem_new);
			aux = NULL;
			pthread_mutex_unlock(&lock);
			//blocam vechiul thread
			sem_wait(sem_curr);
			}
	//daca cuanta nu expira acum
	} else {
		//decrementam cuanta threadului curent
		curr_thread->cuanta--;
		//daca exista un alt thread cu prioritate mai mare
		//in coada de asteptare decat al threadului curent
		if (queue_ready->arr[0].priority > curr_thread->priority) {
			//printf("[check_ROUND_ROBIN] daca threadul_next
			//are prioritate mai mare ca curr_thread\n");
			pop(queue_ready, aux);
			add(queue_ready, curr_thread);

			aux->cuanta = time_quant;

			sem_curr = curr_thread->semafor;
			sem_new = aux->semafor;

			free(curr_thread);

			curr_thread = aux;
			//dam drumul la noul thread
			sem_post(sem_new);
			aux = NULL;
			pthread_mutex_unlock(&lock);
			//blocam vechiul thread
			sem_wait(sem_curr);
		} else
			pthread_mutex_unlock(&lock);
	}
	//printf("[check_ROUND_ROBIN] iesire\n");
}

int so_init(unsigned int time_quantum, unsigned int io)
{
	printf("[init] intrare\n");
	//daca parametrii nu sunt buni sau no_io respectiv
	// time_quant nu au fost initializati deja initializati
	if ((no_io != MAX && time_quant != MAX) ||
		io > SO_MAX_NUM_EVENTS || time_quantum < 1)
		return ERROR;

	time_quant = time_quantum;
	no_io = io;

	queue_ready = (PQueue *)malloc(sizeof(PQueue));

	if (queue_ready == NULL)
		return ERROR_MALLOC;
	//initializeaza coada
	queue_ready->size = 1;
	queue_ready->curr_position = 0;
	queue_ready->arr = (T_info *)malloc(queue_ready->size * sizeof(T_info));

	if (queue_ready->arr == NULL) {
		free(queue_ready);
		return ERROR_MALLOC;
	}

	//alocam vectorul de threaduri blocate
	queue_blocked = (PQueue *)malloc(sizeof(PQueue));

	if (queue_blocked == NULL) {
		free(queue_ready->arr);
		free(queue_ready);
		return ERROR_MALLOC;
	}
	//initializeaza coada de blocked. Se comporta ca un array
	//la adaugare (apeleaza add_threads in loc de add)
	queue_blocked->size = 1;
	queue_blocked->curr_position = 0;
	queue_blocked->arr = malloc(queue_blocked->size * sizeof(T_info));

	if (queue_blocked->arr == NULL) {
		free(queue_ready->arr);
		free(queue_ready);
		free(queue_blocked);
		return ERROR_MALLOC;
	}

	//initializeaza coada pt toate threadurile
	//folosita pentru a face join la so_end
	//Se comporta ca un array la adaugare(apeleaza add_threads)
	threads = (PQueue *)malloc(sizeof(PQueue));

	if (threads == NULL) {
		free(queue_ready->arr);
		free(queue_ready);
		free(queue_blocked->arr);
		free(queue_blocked);
		return ERROR_MALLOC;
	}

	threads->size = 1;
	threads->curr_position = 0;
	threads->arr = (T_info *)malloc(threads->size * sizeof(T_info));

	if (threads->arr == NULL) {
		free(queue_ready->arr);
		free(queue_ready);
		free(queue_blocked->arr);
		free(queue_blocked);
		free(threads);
		return ERROR_MALLOC;
	}

	curr_thread = malloc(sizeof(T_info));
	curr_thread->thread_id = UNINITALIZED_THREAD;
	start = 1;
	printf("[init] time_quant = %d\n", time_quantum);
	printf("[init] iesire\n");

	return 0;
}

tid_t so_fork(so_handler *func, unsigned int priority)
{
	static int no_threads;
	char name_shared_sem[20];
	int res;
	//printf("[so_fork] intrare\n");
	Args *args;
	tid_t tid;

	if (func == NULL || priority > SO_MAX_PRIO)
		return INVALID_TID;

	args = (Args *)malloc(sizeof(Args));

	sprintf(args->nume_semafor, "sem_no_%d", no_threads);
	sprintf(name_shared_sem, "shared_%d", no_threads);
	no_threads++;

	args->priority = priority;

	args->shared_sem = sem_open(name_shared_sem, O_CREAT, 0644, 0);
	DIE(args->shared_sem == SEM_FAILED,
		"eroare la sem_open shared_sem\n");

	args->semafor_child = sem_open(args->nume_semafor, O_CREAT, 0644, 0);
	DIE(args->semafor_child == SEM_FAILED,
		"eroare la sem_open semafor_child\n");

	args->handler = func;

	res = pthread_create(&tid, NULL, &function, args);
	DIE(res != 0, "failed to create thread\n");

	//printf("[so_fork] astept la sem->wait()\n");
	sem_wait(args->shared_sem);
	//printf("[so_fork] am trecut de sem->wait()\n");

	//daca nu e cazul cand se creeaza primul thread
	//verificam care thread are dreptul sa ruleze
	//actualizand si cuanta
	if (start == 0)
		check_ROUND_ROBIN();

	//daca e cazul de inceput pentru primul thread nu
	// are sens sa mai planificam nimic intrucat el
	// e deja ales din function inainte de a semnaliza
	//semaforul shared(deci inainte de a ajunge aici)
	pthread_mutex_lock(&lock);
	if (start == 1)
		start = 0;
	pthread_mutex_unlock(&lock);

	//printf("[so_fork] am trecut de check_ROUND_ROBIN\n");

	//distruge semaforul shared
	res = sem_close(args->shared_sem);
	DIE(res == -1, "eroare la sem_close\n");

	res = sem_unlink(name_shared_sem);
	DIE(res == -1, "eroare la sem_unlink\n");

	//printf("[so_fork] am creat threadul cu id = %llu
	//si prioritatea = %d\n", tid, priority);
	//printf("[so_fork] iesire\n");

	return tid;
}

int so_wait(unsigned int io)
{
	//printf("[so_wait] intrare\n");
	int res;
	sem_t *sem_curr;
	sem_t *sem_new;

	if ((int)io < 0 || io >= (unsigned int)no_io)
		return ERROR;

	pthread_mutex_lock(&lock);
	//daca threadul curent e NULL eliberam mutexul
	//si inchidem
	if (curr_thread == NULL) {
		pthread_mutex_unlock(&lock);
		return 0;
	}
	//acutalizam cuanta
	curr_thread->cuanta--;

	curr_thread->eveniment = io;
	//adauga threadul current la coada de blocked
	add_threads(queue_blocked, curr_thread);
	sem_curr = curr_thread->semafor;
	//obtine threadul cu prioritatea cea mai mare din coada ready
	res = pop(queue_ready, curr_thread);

	//daca am scos ceva din coada de prioritati refacem threadul cur.
	if (res == 0) {
		sem_new = curr_thread->semafor;
		//resetam cuanta cu cea default;
		curr_thread->cuanta = time_quant;

		sem_post(sem_new);
		pthread_mutex_unlock(&lock);
		sem_wait(sem_curr);
	//altfel blocam threadul current
	} else {
		sem_curr = curr_thread->semafor;
		pthread_mutex_unlock(&lock);
		curr_thread = NULL;
		sem_wait(sem_curr);
	}
	//printf("[so_wait] iesire\n");
	return 0;
}



int so_signal(unsigned int io)
{
	//printf("[so_signal] intrare\n");
	int no_threads;
	int i;

	if (io >= no_io)
		return ERROR;

	no_threads = 0;

	pthread_mutex_lock(&lock);
	//scoatem din blocked acele threaduri care asteapta dupa
	//evenimentul io si le adaugam in coada de prioritati ready
	//Actualizam si campul eveniment al acestora
	for (i = 0; i < queue_blocked->curr_position ; i++) {
		if (queue_blocked->arr[i].eveniment == (int)io) {
			queue_blocked->arr[i].eveniment = NO_EVENT;
			add(queue_ready, &queue_blocked->arr[i]);
			delete_threads(queue_blocked, &queue_blocked->arr[i]);
			i--;
			no_threads++;
		}
	}

	pthread_mutex_unlock(&lock);

	check_ROUND_ROBIN();
	//printf("[so_signal] iesire\n");
	return no_threads;
}

void so_exec(void)
{
	//printf("[so_exec] intrare\n");

	pthread_mutex_lock(&lock);

	if (curr_thread == NULL) {
		pthread_mutex_unlock(&lock);
		return;
	}

	pthread_mutex_unlock(&lock);

	//functie care alege folosind ROUND-ROBIN threadul care are voie
	// sa ruleze , dupa ce decrementeaza cuanta threadului curent.
	check_ROUND_ROBIN();

	//printf("[so_exec]id = %llu iesire\n", curr_thread->thread_id);

}

void so_end(void)
{
	int i;
	//printf("[so_end] intrare\n");

	//if (threads)
	//	show(threads);

	//daca nu avem initializate numarul de dispozitive
	//sau cuanta de timp alocabila pe procesor inseamna
	//ca nu s-a apelat so_init in prealabil, deci ne oprim
	if (no_io == MAX || time_quant == MAX)
		return;

	//asteptam threadurile din array-ul threads
	for (i = 0; i < threads->curr_position; i++)
		pthread_join(threads->arr[i].thread_id, NULL);

	//printf("[so_end] am trecut de join\n");

	//dezalocam cele 3 cozi
	if (queue_ready != NULL)
		free_queue(&queue_ready);
	if (queue_blocked != NULL)
		free_queue(&queue_blocked);
	if (threads != NULL)
		free_queue(&threads);
	//dezalocam current thread
	if (curr_thread != NULL)
		free(curr_thread);
	//reinitilizam valorile de la inceput
	curr_thread = NULL;
	no_io = -1;
	time_quant = -1;
	start = 0;

	//printf("[so_end] iesire\n");
}
