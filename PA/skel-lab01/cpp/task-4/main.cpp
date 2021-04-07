#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

class Task {
public:
	void solve() {
		read_input();
		print_output(fast_pow(base, exponent, mod));
	}

private:
	int base, exponent, mod;

	void read_input() {
		ifstream fin("in");
		fin >> base >> exponent >> mod;
		fin.close();
	}

	long long fast_pow(int base, int exponent, int mod) {
		// TODO: Calculati (base ^ exponent) % mod in O(log exponent)

		if ( exponent == 0 )
			return 1 ;
		if ( exponent == 1 )
			return base ;
		if ( exponent % 2 == 0 )
		{
			long long aux = fast_pow(base, exponent / 2 , mod) ;
			aux = aux % mod ;
			return ( aux * aux ) % mod ;
		}
		else
			return ( base * fast_pow( base ,  exponent - 1, mod ) ) % mod  ;

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
