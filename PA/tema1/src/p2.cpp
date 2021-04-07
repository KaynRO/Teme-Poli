#include <bits/stdc++.h>
#include <fstream>

#define NMAX 1005

using namespace std ;

ofstream fout("p2.out") ;

int N, K, DP[NMAX][NMAX] ;
vector<int> V ;

void read()
{

    int elem ;
    freopen("p2.in", "r", stdin) ;
    scanf("%d %d", &N, &K) ;

    for(int i = 0 ; i < N ; i++)
        scanf("%d", &elem), V.push_back(elem) ;
}

int main()
{

    read() ;
    sort(V.begin(), V.end(), greater<int>()) ;

    DP[1][0] = V[0] ;
    DP[1][1] = 0 ;

    for(int i = 2 ; i <= N ; i++)
        for(int j = 0 ; j <= min(K, i); j++)
        {
            DP[i][j] = 0 ;
            if(j != i){
                if((i - j) % 2 != 0)
                    DP[i][j] = max(DP[i - 1][j - 1], DP[i - 1][j] + V[i - 1]) ;
                else DP[i][j] = max(DP[i - 1][j - 1], DP[i - 1][j] - V[i - 1]) ;
            }
        }

    fout << DP[N][K] ;
}