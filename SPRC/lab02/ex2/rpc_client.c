#include <stdio.h>
#include <rpc/rpc.h>

#include "grade.h"
#define RMACHINE "sprc2.dfilip.xyz"

int main(int argc, char *argv[]){
    CLIENT *handle;
    struct student st;
    char *text = (char*) malloc (TEXT_LENGTH * sizeof(char));
    st.nume = (char*) malloc (TEXT_LENGTH * sizeof(char));
    st.grupa = (char*) malloc (TEXT_LENGTH * sizeof(char));

    handle = clnt_create(
                RMACHINE,
                CHECK_PROG,
                CHECK_VERS,
                "tcp"
    );

    if (handle == NULL){
        perror("Handle creation returned NULL");
        return -1;
    }

    printf("Nume: ");
    scanf("%s", st.nume);
    printf("Grupa: ");
    scanf("%s", st.grupa);

    text = *grade_1(&st, handle);
    printf("%s", text);


    return 0;
}