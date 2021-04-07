#include <bits/stdc++.h>
#include <fstream>

#define NMAX 1005

using namespace std ;

ofstream fout("p3.out") ;

int N ;
long long DP[NMAX][NMAX] ;
vector<int> V ;

void read()
{

    int elem ;
    freopen("p3.in", "r", stdin) ;
    scanf("%d", &N) ;

    for(int i = 0 ; i < N ; i++)
        scanf("%d", &elem), V.push_back(elem) ;
}

int main()
{
    // DP[i][j] = cel mai bun subsir de i elemente ce incepe la pozitia j
    read() ;

    for(int i = 0 ; i < N ; i++)
        DP[1][i] = (N % 2 == 0) ? -V[i] : V[i] ;

    for(int i = 2 ; i <= N ; i++)
        for(int j = 0 ; j <= N - i ; j++)
            if( (N - i) % 2 == 0 )
                DP[i][j] = max(V[j] + DP[i - 1][j + 1], V[j + i - 1] + DP[i - 1][j]) ;
            else
                DP[i][j] = min(DP[i - 1][j + 1] - V[j], DP[i - 1][j] - V[j + i - 1]) ;

    fout << DP[N][0] ;

}