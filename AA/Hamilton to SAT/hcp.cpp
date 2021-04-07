#include <fstream>
#include <vector>
#include <algorithm>
#include <string>
#define NMAX 1000

using namespace std ;

ifstream fin("graph.in") ;
ofstream fout("bexpr.out") ;

vector<int> V[NMAX] ;
int from, to , N ;
vector<int> :: iterator adj1, adj2 , adj3 ;

void AnotA(int A, int B)
{
	fout << "x" << A << "-" << B << "|~x" << B << "-" << A ;
}

void oneTrue(int length, int node, bool ok)
{

	if(ok == 1)
		fout << "&" ;
	fout << "(" ;
	if(ok)
		fout << "~" ;
	fout << "a" << length << "-" << node << "|" ;
	if(!ok)
		fout << "~" ;

	if(length == 1)
		fout << "x1" << "-" << node << ")" ;
	else
	{
		fout << "(" ;
		if(V[node].size() > 0)
			fout << "((" ;
		for(adj1 = V[node].begin() ; adj1 != V[node].end() ; ++adj1)
		{
			if(*adj1 != 1)
				for(adj2 = V[node].begin() ; adj2 != adj1 ; ++adj2)
					if(*adj2 != 1)
					{
						fout << "|(" ;
						break;
					}

			if(*adj1 != 1)
				fout << "a" << length - 1 << "-" << *adj1 << "&x" << node << "-" << *adj1 << ")" ;
			
			if(adj1 == V[node].end() - 1)
				fout << ")" ;
		}

		for(int less = 1 ; less < length ; ++less)
		{
			if(less == 1)
				fout << "&~(" ;
			else 
				fout << "|" ;
			fout << "a" << less << "-" << node ;
			if(less == length - 1)
				fout << ")" ;
			if(V[node].size() > 0 && less == length - 1)
				fout << "))" ;
		}

	}
}

int main()
{
	fin >> N ;
	fin >> from ;

	while(from != -1)
	{
		fin >> to ;
		V[from].push_back(to) ;
		V[to].push_back(from) ;
		fin >> from ;
	}

    //Part I, deg(x) >= 2
	//&((x2-1&x2-3&~x2-4)|(x2-1&x2-4&~x2-3)|(x2-3&x2-4&~x2-1))&(a1-2|a2-2|a3-2)
	for(int node = 1 ; node <= N ; ++node)
	{
		if(node != 1 && node != N)
			fout << "&" ;

		if(node != N)
			fout << "(" ;

		if(node != N)
			for(adj1 = V[node].begin() ; adj1 != V[node].end() - 1 ; ++adj1)
			{
				for(adj2 = adj1 + 1 ; adj2 != V[node].end() ; ++adj2)
				{

					fout << "(" << "x" << node << "-" << *adj1 << "&x" << node << "-" << *adj2 ;

						for(adj3 = V[node].begin() ; adj3 != V[node].end(); ++adj3)
							if(adj3 != adj2 && adj3 != adj1)
								fout << "&~" << "x" << node << "-" << *adj3 ;

					if(adj3 == V[node].end())
						fout << ")" ;
					if(adj3 == V[node].end() && !(adj1 == (V[node].end() - 2) && adj2 == (V[node].end() - 1)) )
						fout << "|" ;
				}
			}

		if(node != N)
			fout << ")" ;

		if(node != 1)
			for(int length = 1 ; length <= N / 2 + 1 ; ++length)
			{
					if(length == 1)
						fout << "&(" ;
					else
						fout << "|" ;

					fout << "a" << length << "-" << node  ;

					if(length == N / 2 + 1)
						fout << ")" ;
			}
	}

    //Part II, any edge be used not more than 1 time
	//&((x1-2|~x2-1)&(~x1-2|x2-1))
	for(int node = 1 ; node <= N ; node++)
		for(adj1 = V[node].begin() ; adj1 != V[node].end() ; ++adj1)
			if(*adj1 > node)
			{
				fout << "&((" ;
				AnotA(node, *adj1) ;
				fout << ")&("  ;
				AnotA(*adj1, node) ;
				fout << "))" ;
			}

    //Part III, any node is accessible from node 1, in other words, our graph is connected(conex)
	//Particular case when distance is 1, for any node that doesn't have a edge with 1 we negate a1-x
	for(int node = 1 ; node <= N ; ++node)
		if(find(V[1].begin() , V[1].end() , node) == V[1].end())
			fout << "&~a1-" << node ;

	//&((a3-2|~(((a2-3&x3-2)|(a2-4&x4-2))&~(a1-2|a2-2)))&(~a3-2|(((a2-3&x3-2)|(a2-4&x4-2))&~(a1-2|a2-2))))
	for(int length = 1 ; length <= N / 2 + 1 ; ++length)
		for(int node = 2 ; node <= N ; ++node)
		{
			if(find(V[1].begin(), V[1].end(), node) == V[1].end() && length == 1)
				continue ;

			fout << "&(" ;
			oneTrue(length, node, 0) ;
			oneTrue(length, node, 1) ;
			fout << ")" ;	
		}

}
