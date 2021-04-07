#include <stdio.h>
#include <stdlib.h>
#define NMAX 1000

int Adj[NMAX][NMAX], x, y, N, ok ;

int main()
{
    FILE* input = fopen("graph.in", "r") ;
    FILE* output = fopen("bexpr.out", "w+") ;
    fscanf(input,"%d", &N) ;
    while(1)
    {
        fscanf(input,"%d", &x) ;
        if(x == -1)
            break ;
        fscanf(input,"%d", &y) ;
        Adj[x][y] = 1 ;
        Adj[y][x] = 1 ;

    }

    for(int i = 1 ; i <= N ; i++)
    {
        ok = 0 ;
        for(int j = 1 ; j <= N ; j++)
            if(Adj[i][j])
            {
                for(int k = j + 1 ; k <= N ; k++)
                    if(Adj[i][k])
                    {
                        if(!ok)
                        {
                            if(i != 1)
                                fprintf(output,"&") ;
                            fprintf(output,"(") ;
                        }
                        if(ok)
                            fprintf(output,"|") ;
                        fprintf(output,"(") ;
                        fprintf(output,"x%d-%d&x%d-%d", i, j, i, k) ;
                        for(int l = 1 ; l <= N ; l++)
                            if(Adj[i][l] && l != j && l != k)
                            {
                                fprintf(output,"&~x%d-%d", i, l) ;
                                ok = 1 ;
                            }
                        fprintf(output,")") ;
                        if(!ok)
                            fprintf(output,")") ;

                    }
            }
        if(ok)
            fprintf(output,")") ;
        if(i != 1)
            for(int j = 1 ; j <= N / 2 + 1 ; j++)
            {
                if(j == 1)
                    fprintf(output,"&(") ;
                fprintf(output,"a%d-%d", j, i) ;
                if(j != N / 2 + 1)
                    fprintf(output,"|") ;
                else fprintf(output,")") ;
            }
    }

    for(int i = 1 ; i <= N ; i++)
        for(int j = i + 1; j <= N ; j++)
            if(Adj[i][j])
                fprintf(output,"&((x%d-%d|~x%d-%d)&(~x%d-%d|x%d-%d))", i, j, j, i, i, j, j, i) ;


    for(int i = 1; i <= N ; i++)
        if(!Adj[1][i])
            fprintf(output,"&~a%d-%d", 1, i) ;

    for(int i = 1 ; i <= N / 2 + 1 ; i++)
        for(int j = 2 ; j <= N ; j++)
        {
            ok = 0 ;
            if(i != 1)
            {
                fprintf(output,"&((a%d-%d|~(", i, j) ;
                for(int k = 1 ; k <= N ; k++)
                {
                    if(!ok && Adj[j][k] && !(i == 2 && k == 1) && !( k == 1 && i > 1))
                        fprintf(output,"(") ;
                    if(ok && Adj[j][k])
                        fprintf(output,"|") ;
                    if(Adj[j][k] && !(i == 2 && k == 1) && !( k == 1 && i > 1)  )
                    {
                        fprintf(output,"(a%d-%d&x%d-%d)", i - 1, k, k, j) ;
                        ok = 1 ;
                    }
                }
                if(ok)
                    fprintf(output,")&~(") ;
                for(int k = 1 ; k < i ; k++)
                {
                    fprintf(output,"a%d-%d", k, j) ;
                    if(k != i - 1)
                        fprintf(output,"|") ;
                }
                fprintf(output,")))") ;

                ok = 0 ;
                fprintf(output,"&(~a%d-%d|(", i, j) ;
                for(int k = 1 ; k <= N ; k++)
                {
                    if(!ok && Adj[j][k] && !(i == 2 && k == 1) && !( k == 1 && i > 1))
                        fprintf(output,"(") ;
                    if(ok && Adj[j][k])
                        fprintf(output,"|") ;
                    if(Adj[j][k] && !(i == 2 && k == 1) && !( k == 1 && i > 1))
                    {
                        fprintf(output,"(a%d-%d&x%d-%d)", i - 1, k, k, j) ;
                        ok = 1 ;
                    }
                }
                if(ok)
                    fprintf(output,")&~(") ;
                for(int k = 1 ; k < i ; k++)
                {
                    fprintf(output,"a%d-%d", k, j) ;
                    if(k != i - 1)
                        fprintf(output,"|") ;
                }
                fprintf(output,"))))") ;
            }
            else if(Adj[1][j])
                fprintf(output,"&((a%d-%d|~x%d-%d)&(~a%d-%d|x%d-%d))", i, j, i, j, i, j, i, j) ;
        }

    return 0 ;
}
