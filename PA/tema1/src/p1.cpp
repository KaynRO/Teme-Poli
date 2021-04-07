#include <bits/stdc++.h>
#include <fstream>

#define NMAX 100005

using namespace std ;

ofstream fout("p1.out") ;

int N ;
vector<int> V ;

void read(){

	int elem ;
	freopen("p1.in", "r", stdin) ;
	scanf("%d", &N) ;

	for(int i = 0 ; i < N ; i++)
		scanf("%d", &elem), V.push_back(elem) ;
}

int main(){

	read() ;
	sort(V.begin(), V.end()) ;

	int sum = 0 ;
	for(int i = V.size() - 1 ; i >= 0 ; i -= 2)
		sum += (i == 0) ? V[i] : V[i] - V[i - 1] ;

	fout << sum ;
}