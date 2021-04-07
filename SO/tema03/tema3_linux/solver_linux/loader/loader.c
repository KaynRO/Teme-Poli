/*
 * Loader Implementation
 *
 * 2018, Operating Systems
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>
#include <signal.h>
#include <fcntl.h>
#include "utils.h"
#include "exec_parser.h"

#define SEG_NOT_FOUND -1
#define DIM_PAGE 4096
#define MAPPED 1
#define UNMAPPED 0  

int fd;
static struct sigaction old_action;
static so_exec_t *exec;

static void segv_handler(int signum, siginfo_t *info, void *context)
{
	int index_seg;
	int index_page;
	void *return_address;
	int addr;
	int no_pages;
	int i;
	uintptr_t start;
	uintptr_t finish;
	char zero_page;

	addr = (int)info->si_addr;
	//cautam indexul segmentului in care este adresa
	for (index_seg = 0; index_seg < exec->segments_no; index_seg++) {
		start = exec->segments[index_seg].vaddr;
		finish = exec->segments[index_seg].vaddr
			+ exec->segments[index_seg].mem_size;
		if (start <= addr && addr <= finish)
			break;
	}
	//daca nu am gasit niciun index de segment,returnam sigsegv
	if (index_seg >= exec->segments_no)
		index_seg = SEG_NOT_FOUND;

	if (index_seg == SEG_NOT_FOUND) {
		old_action.sa_sigaction(SIGSEGV, info, context);
		return;
	}

	//aflam cate pagini complete exista in acel segment
	no_pages = exec->segments[index_seg].file_size / DIM_PAGE;

	//cautam indexul paginii din segment
	index_page = (addr - (int)exec->segments[index_seg].vaddr)/DIM_PAGE;

	//daca a fost mapat deja inseamna trimitem sigsegv intrucat
	//segfault se datoreaza lipsei unor permisiuni pe acea zona
	if (*((char *)exec->segments[index_seg].data + index_page) == MAPPED) {
		old_action.sa_sigaction(SIGSEGV, info, context);
		return;
	}
	//daca nu file_size nu se imparte exact la DIM_PAGE
	//inseamna ca o sa mai avem o pagina cu o parte de info
	//si restul 0-uri.
	zero_page = (exec->segments[index_seg].file_size % DIM_PAGE == 0)?0:1;

	//daca index_page e mai mic decat no_pages vom mapa o pagina intrega
	if (index_page < no_pages) {
		void *address;
		int prot;
		int flags;
		uintptr_t fd_address;

		address = exec->segments[index_seg].vaddr
			+ index_page * DIM_PAGE;

		prot = PROT_READ | PROT_WRITE | PROT_EXEC;

		flags = MAP_PRIVATE | MAP_FIXED;

		fd_address = exec->segments[index_seg].offset
			+ index_page * DIM_PAGE;

		return_address = mmap(address, DIM_PAGE, prot,
				flags, fd, fd_address);

		//daca am avut eroare la mmap
		if (return_address == MAP_FAILED) {
			old_action.sa_sigaction(SIGSEGV, info, context);
			return;
		}
	//daca sunt egale si file_size-ul
	//daca nu e multiplu de DIM_PAGE
	} else if (index_page == no_pages && zero_page == 1) {
		void *address;
		int prot;
		int flags;
		uintptr_t fd_address;
		int length;
		int size;
		char *ptr_address;

		address = exec->segments[index_seg].vaddr
			+ index_page * DIM_PAGE;

		prot = PROT_READ | PROT_WRITE | PROT_EXEC;

		flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED;

		fd_address = exec->segments[index_seg].offset
			+ index_page * DIM_PAGE;

		return_address = mmap(address, DIM_PAGE, prot, flags, 0, 0);

		lseek(fd, fd_address, SEEK_SET);

		size = exec->segments[index_seg].file_size;
		length = size - size/DIM_PAGE * DIM_PAGE;

		char *buffer = (char *)malloc(length * sizeof(char));

		if (read(fd, buffer, length) < 0)
			return;

		ptr_address = (char *)address;

		for (i = 0; i < DIM_PAGE; i++) {
			if (i < length)
				ptr_address[i] = buffer[i];
			else
				ptr_address[i] = 0;
		}

		//daca am avut eroare la mmap
		if (return_address == MAP_FAILED) {
			old_action.sa_sigaction(SIGSEGV, info, context);
			return;
		}
	//altfel
	} else {
		void *address;
		int prot;
		int flags;
		uintptr_t fd_address;

		address = exec->segments[index_seg].vaddr
			+ index_page * DIM_PAGE;
		prot = PROT_READ | PROT_WRITE | PROT_EXEC;
		flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED;
		fd_address = 0;

		return_address = mmap(address, DIM_PAGE, prot,
				flags, 0, fd_address);

		//daca am avut eroare la mmap
		if (return_address == MAP_FAILED) {
			old_action.sa_sigaction(SIGSEGV, info, context);
			return;
		}
	}

	//daca am ajuns aici inseamna ca am mapat pagina
	//si nu am avut erori pana acum
	int res = mprotect(return_address, DIM_PAGE,
			exec->segments[index_seg].perm);
	DIE(res == -1, "eroare la mprotect");
	//actualizam maparea paginii
	*((char *)exec->segments[index_seg].data + index_page) = MAPPED;
}

int so_init_loader(void)
{
	int result;
	struct sigaction action;

	action.sa_sigaction = segv_handler;
	sigemptyset(&action.sa_mask);
	sigaddset(&action.sa_mask, SIGSEGV);
	action.sa_flags = SA_SIGINFO;

	result = sigaction(SIGSEGV, &action, &old_action);

	DIE(result == -1, "sigaction");

	return result;
}

int so_execute(char *path, char *argv[])
{
	int i, j;

	exec = so_parse_exec(path);

	//daca avem eroare la so_parse_exec returnam eroare
	if (!exec)
		return -1;

	//deschide fisierul
	fd = open(path, O_RDONLY);

	//daca nu exista returneaza eroare
	if (fd < 0)
		return -1;

	/* init data (used as a way to identify if a page is mapped) */
	for (i = 0; i < exec->segments_no; i++) {
		int no_pages;

		no_pages = exec->segments[i].mem_size / DIM_PAGE;

		exec->segments[i].data =
			(char *)malloc(no_pages * sizeof(char));

		for (j = 0; j < no_pages; j++)
			*(char *)(exec->segments[i].data + j) = 0;
	}

	so_start_exec(exec, argv);

	return -1;
}

