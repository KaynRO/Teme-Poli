#include <fstream>
#include <iomanip>
#include <vector>
#include <algorithm>
#include <iostream>
#define INF (1 << 30)
#define NMAX 10000
using namespace std;

class Task {
 public:
	void solve() {
		read_input();
		print_output(get_result());
	}

 private:
	int n, S;
	vector<int> v;

	void read_input() {
		ifstream fin("in");
		fin >> n >> S;
		v.push_back(-1); // adaugare element fictiv - indexare de la 1
		for (int i = 1, e; i <= n; i++) {
			fin >> e;
			v.push_back(e);
		}
		fin.close();
	}

	int get_result() {
		/*
		TODO: Aflati numarul minim de monede ce poate fi folosit pentru a obtine
		suma S. Tipurile monedelor sunt stocate in vectorul v, de dimensiune n.
		*/
		int dp[NMAX] ;
		dp[0] = 0 ;

		for(int i = 1 ; i <= S ; i++)
			dp[i] = INF;

		for(int i = 1 ; i <= S ; i++)
			for(int j = 1 ; j <= n ; j++)
				if(v[j] <= i)
					dp[i] = min(dp[i], dp[i - v[j]] + 1);

		if(dp[S] == INF)
			return -1 ;

		return dp[S] ;
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
