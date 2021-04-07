#include <stdio.h>
#include <string.h>
#include "compare.h"
#include <stdlib.h>
#define bsize 20000
typedef struct C{
	struct C *next;
	char continut[bsize];
	int prioritate;

};

struct C *insert(struct C *start, char *continut, int prior)
{
	struct C *intermediar = NULL;
	struct C *end = NULL;
	if (start == NULL){
		start = (struct C*)malloc(sizeof(struct C));
		strcpy(start->continut, continut);
		start->prioritate = prior;
		start->next = NULL;
	}else{
		struct C *sd = NULL;
		sd = (struct C*)malloc(sizeof(struct C));
		strcpy(sd->continut, continut);
		sd->prioritate = prior;
		sd->next = NULL;
		intermediar = start;
		int retine = 1;
		struct C *intermediar2 = NULL;
		intermediar2 = start;
		while (intermediar->next != NULL)
		{
			if (retine == 0){
				intermediar2 = intermediar2->next;
			}
			if (compare(sd->prioritate, intermediar->prioritate) > 0){
				if (intermediar == start){
					sd->next = start;
					start = sd;
				}else
				{
					end = start;
					while (end->next != intermediar)
					{
						end = end->next;
					}
					end->next = sd;
					sd->next = intermediar;
				}
				break;
			}
			intermediar = intermediar->next;
			retine = 0;
		}
		if (intermediar->next == NULL){
			if (compare(sd->prioritate, intermediar->prioritate) < 0)
				intermediar->next = sd;
			else{
				if (intermediar == start){
					start = sd;
					sd->next = intermediar;
				}
				else{
					intermediar2->next = sd;
					sd->next = intermediar;
				}
			}
		}
	}
	return start;
}
struct C *pop(struct C *start)
{
	struct C *intermediar;
	if (start != NULL){
		intermediar = start->next;
		start->next = NULL;
		free(start);
		start = intermediar;
	}
	return start;
}
void top(struct C *start)
{
	if (start != NULL){
		printf("%s \n", start->continut);
	}
	else{
		printf("\n");
	}
}
int main(int argc, char*argv[])
{
	struct C *start = NULL;
	char *p = NULL;
	char *str = NULL;
	int i = 1, j = 1;
	char *s;
	char *continut = NULL;
	int prior = -1;
	str = (char*)malloc(30);
	p = (char*)malloc(bsize);
	memset(p, 0, bsize);
	while (j < argc|| j==1)
	{
		for (i = j; i < argc; i++)
		{
			FILE *fp;
			if (argc == 1)
				fp = stdin;
			else
			{
				fp = fopen(argv[i], "rt");
				if (fp == NULL)
					break;
			}
			while (fgets(p, bsize, fp))
			{
				s = (char*)malloc(strlen(p) + 1);
				continut = (char*)malloc(strlen(p) + 1);
				sscanf(p, "%s %s %d\n", s, continut, &prior);
				if (strcmp(s, "insert") == 0 && continut != NULL && prior != -1){
					sprintf(str, "%d", prior);
					int a = strlen(s) + strlen(continut) + strlen(str);
					int b = strlen(p) - 3;
					if (b == a){
						int k = 0;
						for (k = 0; k < strlen(continut); k++)
						{
							if (continut[k] - 'a' < 0 || continut[k] - 'a' > 25){
								break;
							}
						}
						if (k >= strlen(continut)){

							start = insert(start, continut, prior);
						}

					}
				}else
				{
					if (strcmp(p, "top") == 0 || strcmp(p, "top\n") == 0){
						top(start);
					}
					if (strcmp(p, "pop") == 0 || strcmp(p, "pop\n") == 0){
						if (start != NULL)
							start = pop(start);
					}
				}

				if (s != NULL){
					free(s);
					s = NULL;
				}
				if (continut != NULL){
					free(continut);
					continut = NULL;
				}
			}
			fclose(fp);
		}
		j++;
	}
	if (str != NULL){
		free(str);
		str = NULL;
	}
	if (p != NULL){
		free(p);
		p = NULL;
	}
	while (start != NULL)
	{
		start = pop(start);
	}
	return 0;
}