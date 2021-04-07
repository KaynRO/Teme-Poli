#include <cmath>
#include <cstdio>
#include <vector>
#include <iostream>
#include <algorithm>
using namespace std;

struct Item
{
    int value ;
    int sign ;
};

struct Comparator
{
    bool operator()(const Item& A, const Item& B)const
    {
        return A.value > B.value ;
    }
};

vector<Item> V ;
int N, changes, X[100005] , total ;
Item x ;

int main() {

    std::ios::sync_with_stdio(false);  
      
    int value ;
    cin >> N >> changes ;
    
    for(int i = 0 ; i < N ; i++)
    {
        cin >> x.value ;
        if(x.value < 0)
            x.sign = -1, x.value *= -1 ;
        else x.sign = 1 ;
        V.push_back(x) ;
    }
    
    sort(V.begin(), V.end(), Comparator()) ;
    
    int i = 0 ;
    while(changes > 0 && i < N)
    {
        total += V[i].value ;
        if(V[i].sign == -1)
            changes-- ;

        i++ ;
    }
    
    for(int i = N - 1 ; i > 0 && changes > 0 ; i++)
        if(V[i].sign == 1)
            total += (-1 * V[i].value * 2), changes -- ;

    while(i < N)
        total += (V[i].value * V[i].sign) , i++ ;
    
    cout << total ;

  
    return 0;
}