#include <bits/stdc++.h>

#define NMAX 100010

using namespace std ;

ofstream fout("p1.out") ;

struct element
{
    int value ;
    int pos ;
};

vector<element> V ;
vector<int> G[NMAX] ;
int N, edges ;

bool comparer(element A, element B)
{
    if(A.value == B.value)
        return A.pos < B.pos ;
    return A.value < B.value ;
}

void read()
{
    element elem ;

    freopen("p1.in", "r", stdin) ;
    scanf("%d", &N) ;

    for(int i = 0 ; i < N ; i++)
        scanf("%d", &elem.value), elem.pos = i + 1, V.push_back(elem) ;
}

int solve()
{
        //We will sort all the values and solve the problem in one iteration O(n)
    int node = 1, next, dist = 1 ;
    bool ok ;
    sort(V.begin(), V.end(), comparer) ;

    if(V[1].value != 1)
        return 0 ;

    for(size_t i = 1 ; i < V.size() ; i++)
    {
        ok = false ;

            //If the value is equal to distance we have a new edge
        if(V[i].value == dist)
        {
            G[node].push_back(V[i].pos) ;
            G[V[i].pos].push_back(node) ;
            next = V[i].pos;
            edges++ ;
            ok = true ;
        }

            //If the node could have edge with a previous one
        if(ok == false && V[i].value == dist + 1)
        {
            dist++ ;
            node = next ;
            i-- ;
            continue ;
        }

            //The graph can't be formed
        if(ok == false && (V[i].value > dist || V[i].value == 0))
            return 0 ;
            //Success
        if(ok == false && dist > V[i].value)
            return 1 ;
    }

    return 1 ;
}

void print()
{
    fout << edges << '\n' ;
    for(int i = 1 ; i <= N ; i++)
        for(size_t j = 0 ; j < G[i].size() ; j++)
            if(G[i][j] > i)
                fout << i << ' ' << G[i][j] << '\n' ;
}

int main()
{
    read() ;
    if(solve())
        print() ;
    else fout << "-1" ;
    return 0 ;
}