#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>

using namespace std;

class Task {
public:
	void solve() {
		read_input();
		print_output(get_result(n, x, y, 1));
	}

private:
	int n, x, y;

	void read_input() {
		ifstream fin("in");
		fin >> n >> x >> y;
		fin.close();
	}

	int get_result(int n, int x, int y, int cnt) {
		/*
		TODO: Calculati valoarea de pe pozitia (x, y) din matricea de dimensiune
		2^n x 2^n
		*/
		
		// Daca ajung intr-un caz de baza vad daca pozitia cautata e printre ele
		if ( n == 1 )
		{
			if ( x == 1 && y == 1 )
				return cnt ;
			if ( x == 1 && y == 2 )
				return cnt + 1 ;
			if ( x == 2 && y == 1 )
				return cnt + 2 ;
			if ( x == 2 && y == 2 )
				return cnt + 3 ;
		}

		int edge = pow( 2, n ) ; // latura curenta
		int adder =  pow( edge, 2 ) / 4 ; // Cate elemente adaug in fiecare sub-patrat
		int mid = edge / 2 ;

		// Altfel ma uit in care din cele 4 sub-patrate trebuie sa ma uit in functie de x,y dat. Cand il gasesc, schimb coordonatele

		//Stanga sus
		if ( x <= mid && y <= mid )
			return get_result( n - 1 , x, y , cnt ) ;

		//Dreapta sus
		if ( x <= mid && y > mid )
			return get_result( n - 1 , x , y - mid , cnt + adder ) ;

		//Stanga jos
		if ( x > mid && y <= mid )
			return get_result( n - 1 , x - mid , y , cnt + 2 * adder) ;

		//Dreapta jos
		if ( x > mid && y > mid )
			return get_result( n - 1 , x - mid , y - mid , cnt + 3 * adder) ;

		return 0 ;
	}

	void print_output(int result) {
		ofstream fout("out");
		fout << result;
		fout.close();
	}
};

int main() {
	Task task;
	task.solve();
	return 0;
}
