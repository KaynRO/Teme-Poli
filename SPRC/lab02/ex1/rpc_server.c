#include <stdio.h>
#include <rpc/rpc.h>

#include "sum.h"

int *get_sum_1_svc(struct sum_req *str_sum, struct svc_req *cl){
    static int sum = 0;
    sum = str_sum->a + str_sum->b;
    return &sum;
}
