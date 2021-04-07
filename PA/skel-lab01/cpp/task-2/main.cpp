#include <iostream>
#include <iomanip>
#include <fstream>
#include <vector>

using namespace std;

class Task {
public:
	void solve() {
		read_input();
		print_output(compute_sqrt());
	}

private:
	double n;

	void read_input() {
		ifstream fin("in");
		fin >> n;
		fin.close();
	}

	double compute_sqrt() {
		/*
		TODO: Calculati sqrt(n) cu o precizie de 0.001
		Precizie de 10^-x = |rezultatul vostru - rezultatul corect| <= 10^-x
		*/
		double left = 0 , right = n / 2 + 1 ;

		while ( left <= right )
		{
			double mid = ( left + right ) / 2 ;
			if( mid * mid == n ) return mid ;
			else
				if( mid * mid > n )
					right = mid - 0.0001 ;
				else left = mid + 0.0001 ;
		}

		return left ;
	}

	void print_output(double result) {
		ofstream fout("out");
		fout << setprecision(4) << fixed << result;
		fout.close();
	}
};

int main() {
	Task task;
	task.solve();
	return 0;
}
