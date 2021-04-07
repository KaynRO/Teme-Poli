#include <fstream>
#include <vector>
#include <string>
#include <algorithm>
using namespace std;

const int kMod = 1e9 + 7;

class Task {
 public:
	void solve() {
		read_input();
		print_output(get_result());
	}

 private:
	int n;
	string expr;

	void read_input() {
		ifstream fin("in");
		fin >> n >> expr;
		expr = " " + expr; // adaugare caracter fictiv - indexare de la 1
		fin.close();
	}

	int get_result() {
		/*
		Calculati numarul de parantezari ale expresiei date astfel incat
		rezultatul sa dea true si returnati restul impartirii numarului
		la 10^9 + 7.
		*/

		//dp[i][0] = suma modurilor de a paranteza pentru a obtine true
		//dp[i][0] = suma modurilor de a paranteza pentru a obtine false

		int dp[1000][2] ;

		for(int i = 0 ; i <= n ; i++)
			dp[i][0] = 0, dp[i][1] = 0 ;

		for(int i = 1 ; i <= n ; i++)
		{
			if(v[i] == 'T')
				if(v[i - 1] == '&')
				{
					dp[i][0] = dp[i - 2][0] + (v[i - 2] == 'T' ? 1 : 0) ;
					dp[i][1] = dp[i - 2][1] + (v[i - 2] == 'F' ? 1 : 0) ;
				if(v[i - 1] == '|')
				{
					dp[i][0] = dp[i - 2][0] + dp[i - 2][1] + 1  ;
				}
				if(v[i - 1] == '^')
				{
					dp[i][0] = dp[i - 2][1] + (v[i - 2] == 'F' ? 1 : 0) ;
					dp[i][1] = dp[i - 2][0] + (v[i - 2] == 'T' ? 1 : 0) ;
				}
		}

		int maxx = -1 ;
		for(int i = 1 ; i <= n ; i++)
			if(dp[i][0] > maxx)
				maxx = dp[i][0] ;
		return maxx ;
	}

	void print_output(int result) {
		ofstream fout("out");
		fout << result << '\n';
		fout.close();
	}
};

int main() {
	Task task;
	task.solve();
	return 0;
}
