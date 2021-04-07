#include <bits/stdc++.h>

#define NMAX 110

using namespace std ;

ofstream fout("p2.out") ;

struct element
{
    int node ;
    int MAX ;
    int MIN ;
    int cnt ;
}el;

int N, M, K, Q[NMAX][NMAX], V[NMAX * NMAX], maxCnt ;
vector<int> G[NMAX * NMAX] ;
queue<element> QQ ;
bitset<NMAX * NMAX> used ;

int value(int i, int j)
{
    return (i - 1) * M + j ;
}

bool bounds(int i, int j)
{
    if(i >= 0 && i <= N && j >= 0 && j <= M)
        return 1 ;
    return 0 ;
}

bool isOk(int node, int maxi, int mini)
{
    //cout << node << ' ' << maxi << ' ' << mini << endl ;
    int a = max(V[node], maxi) ;
    int b = min(V[node], mini) ;
    if(a - b <= K)
        return 1 ;
    return 0 ;
}

void read()
{
    freopen("p2.in", "r", stdin) ;
    scanf("%d %d %d", &N, &M, &K) ;

    for(int i = 1 ; i <= N ; i++)
        for(int j = 1 ; j <= M ; j++)
            scanf("%d", &Q[i][j]) ;

    for(int i = 1 ; i <= N ; i++)
        for(int j = 1 ; j <= M ; j++)
        {
            if(bounds(i + 1, j))
                G[value(i, j)].push_back(value(i + 1, j)), G[value(i + 1, j)].push_back(value(i, j)) ;
            if(bounds(i, j + 1))
                G[value(i, j)].push_back(value(i, j + 1)), G[value(i, j + 1)].push_back(value(i, j)) ;
            V[value(i, j)] = Q[i][j] ;
        }
}

int BFS(int node)
{
    el.node = node ;
    el.MAX = V[node] ;
    el.MIN = V[node] ;
    el.cnt = 1 ;

    int maxi = -1 ;
    used[node] = 1 ;
    QQ.push(el) ;

    while(!QQ.empty())
    {
        el = QQ.front() ;
        QQ.pop() ;

        for(size_t i = 0 ; i < G[el.node].size() ; i++)
        {
            int next = G[el.node][i] ;
            bool status = isOk(next, el.MAX, el.MIN) ;

            if(!used[next] && status)
            {
                used[next] = 1 ;
                el.node = next ;
                el.MAX = max(el.MAX, V[next]) ;
                el.MIN = min(el.MIN, V[next]) ;
                el.cnt = el.cnt + 1 ;
                QQ.push(el) ;
            }

            if(!status)
                maxi = max(maxi, el.cnt) ;
        }
    }
    cout << endl ;
    return maxi ;
}

int main()
{
    read() ;

    for(int i = 1 ; i <= N * M ; i++)
    {
        maxCnt = max(maxCnt, BFS(i)) ;
        used.reset() ;
    }

    fout << maxCnt ;
    return 0 ;
}
