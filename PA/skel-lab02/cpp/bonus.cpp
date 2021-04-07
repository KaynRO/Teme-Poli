#include <bits/stdc++.h>

using namespace std ;

struct Object
{
	int price1 ;
	int price2 ;
	int adder ;
};

struct Comparator{
	bool operator()(const Object& A, const Object& B)const
	{
		return A.adder > B.adder ;
	}
};

int N, K , total ;
Object x ;

vector<Object> Prices ;
vector<int> X ;

void read()
{
	int aux;
	cin >> N >> K ;

	for(int i = 0 ; i < N ; i++)
	{
		cin >> aux ;
		X.push_back(aux) ;
	}

	for(int i = 0 ; i < N ; i++)
	{
		cin >> x.price2 ;
		x.price1 = X[i] ;
		x.adder = x.price2 - x.price1 ;
		Prices.push_back(x) ;
	}


	sort(Prices.begin(), Prices.end(), Comparator()) ;
}

int main()
{
	read() ;

	int i ;

	for(i = 0 ; i < K && i < N ; i++)
		total += Prices[i].price1 ;

	while(Prices[i].adder > 0)
		total += Prices[i++].price1 ;

	for(int j = i ; j < N ; j++)
		total += Prices[j].price2 ;

	cout << total ;
}