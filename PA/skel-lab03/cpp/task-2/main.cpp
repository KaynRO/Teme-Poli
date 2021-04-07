#include <fstream>
#include <iostream>
#include <vector>
#include <algorithm>
#define NMAX 1000
using namespace std;

struct Result {
	int len;
	vector<int> subsequence;
};

class Task {
 public:
	void solve() {
		read_input();
		print_output(get_result());
	}

 private:
	int n, m;
	vector<int> v;
	vector<int> w;

	void read_input() {
		ifstream fin("in");
		fin >> n >> m;

		v.push_back(-1); // adaugare element fictiv - indexare de la 1
		for (int i = 1, e; i <= n; i++) {
			fin >> e;
			v.push_back(e);
		}

		w.push_back(-1); // adaugare element fictiv - indexare de la 1
		for (int i = 1, e; i <= m; i++) {
			fin >> e;
			w.push_back(e);
		}

		fin.close();
	}

	Result get_result() {
		Result result;
		result.len = 0;

		/*
		TODO: Aflati cel mai lung subsir comun intre v (de lungime n)
		si w (de lungime m).
		Se puncteaza separat urmatoarele 2 cerinte:
		2.1. Lungimea CMLSC. Rezultatul pentru cerinta aceasta se va pune in
		``result.len``.
		2.2. Reconstructia CMLSC. Se puncteaza orice subsir comun maximal valid.
		Solutia pentru aceasta cerinta se va pune in ``result.subsequence``.
		*/

		int dp[NMAX][NMAX] ;
		int minn = 0 ;

		for(int i = 1 ; i <= n ; i++)
			dp[i][0] = 0 ;
		for(int j = 1 ; j <= m ; j++)
			dp[0][j] = 0 ;
		for(int i = 1 ; i <= n ; i++)
			for(int j = 1; j <= m ; j++)
				dp[i][j] = (v[i] == w[j])? dp[i - 1][j - 1] + 1 : max(dp[i - 1][j], dp[i][j - 1]) ;

		result.len = dp[n][m] ;

		int i = n , j = m ;
		while( i != 0 && j != 0)
		{
			if(dp[i][j] == dp[i - 1][j - 1] + 1)
				result.subsequence.push_back(v[i]), i--, j-- ;
			else 
				if(dp[i - 1][j] == dp[i][j - 1])
				{
					i-- ;
					j-- ;
				}
				else
					if(dp[i][j] == dp[i - 1][j])
						i--;
					else 
						if(dp[i][j] == dp[i][j - 1])
							j--;
		}

		return result;
	}

	void print_output(Result result) {
		ofstream fout("out");
		fout << result.len << '\n';
		reverse(result.subsequence.begin(), result.subsequence.end()) ;
		for (int x : result.subsequence) {
			fout << x << ' ';
		}
		fout << '\n';
		fout.close();
	}
};

int main() {
	Task task;
	task.solve();
	return 0;
}
