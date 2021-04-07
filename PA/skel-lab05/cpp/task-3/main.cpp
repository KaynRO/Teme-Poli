#include <fstream>
#include <vector>
#include <algorithm>
#include <cmath>
using namespace std;

class Task {
 public:
	void solve() {
		read_input();
		print_output(get_result());
	}

 private:
	int n;
	vector<vector<int> > all;

	void read_input() {
		ifstream fin("in");
		fin >> n;
		fin.close();
	}

	int check(int col, int line, vector<int> sol){
		for(int i = 0 ; i < sol.size() ; i++){
			if(sol[i] == col)
				return 0 ;
			if(abs(col - sol[i]) == abs(line - i))
				return 0 ;
		}
		return 1 ;
	}

	void bkt(int n, int step, vector<int> sol, int* ok){
		if(step == n){
			all.push_back(sol) ;
			*ok = 1 ;
		}
		else if(*ok == 0)
			for(int col = 1 ; col <= n && *ok == 0 ; col++)
				if(check(col, step, sol)){
					sol.push_back(col) ;
					bkt(n, step + 1, sol, ok) ;
					sol.erase(sol.end() - 1) ;
				}
	}

	vector<int> get_result() {
		vector<int> sol ;
		int ok = 0 ;

		bkt(n, 0, sol, &ok) ;
		sol = all[0];

		/*
		TODO: Gasiti o solutie pentru problema damelor pe o tabla de dimensiune
		n x n.

		Pentru a plasa o dama pe randul i, coloana j:
			sol[i] = j.
		Randurile si coloanele se indexeaza de la 1 la n.

		De exemplu, configuratia (n = 5)
		X----
		--X--
		----X
		-X---
		---X-
		se va reprezenta prin sol[1..5] = {1, 3, 5, 2, 4}.
		*/

		return sol;
	}

	void print_output(vector<int> result) {
		ofstream fout("out");
		for (int i = 0; i <= n - 1; i++) {
			fout << result[i] << (i != n ? ' ' : '\n');
		}
		fout.close();
	}
};

int main() {
	Task task;
	task.solve();
	return 0;
}
