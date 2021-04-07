#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int mystery1(char* s);
extern int mystery2(char* s, char x);
extern int mystery3(char* s, char* p, int x);
extern void mystery4(char*s, char*p, int x);
extern int mystery5(char q);
extern void mystery6(char* s);
extern int mystery7(char* s);
extern int mystery8(char* s, char* p, int x);
extern int mystery9(char* s, int start, int end, char* p);

int main()
{
   char* s = (char*) malloc(sizeof(char) * 100) ;
   strcpy(s, "") ;

   char* p = (char*) malloc(sizeof(char) * 30) ;
   strcpy(p, "A") ;

   char q = 'r' ;

   printf("%d", mystery2(s, q)) ;
   return 0 ;
}
