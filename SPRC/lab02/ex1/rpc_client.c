#include <stdio.h>
#include <rpc/rpc.h>

#include "sum.h"
#define RMACHINE "localhost"

int main(int argc, char *argv[]){
    CLIENT *handle;
    struct sum_req str_sum;
    int *sum;

    handle = clnt_create(
                RMACHINE,
                SUM_PROG,
                SUM_VERS,
                "tcp"
    );

    if (handle == NULL){
        perror("Handle creation returned NULL");
        return -1;
    }

    printf("Introduceti cele 2 numere: ");
    scanf("%d %d", &str_sum.a, &str_sum.b);
    sum = get_sum_1(&str_sum, handle);

    printf("The sum of numbers is: %d", *sum);
    return 0;
}