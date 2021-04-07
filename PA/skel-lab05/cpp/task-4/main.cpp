#include <fstream>
#include <vector>
#include <algorithm>
using namespace std;

class Task {
 public:
	void solve() {
		read_input();
		print_output(get_result());
	}

 private:
	int n, k, sum = 0;
	string caractere;
	vector<int> freq;
	vector<vector<char> > all;

	void read_input() {
		ifstream fin("in");
		fin >> n >> k;
		fin >> caractere;
		caractere = " " + caractere; // Adaugare element fictiv -
									 // indexare de la 1.
		freq.push_back(-1); // Adaugare element fictiv - indexare de la 1.
		for (int i = 1, f; i <= n; i++) {
			fin >> f;
			freq.push_back(f);
		}

		for(int i = 1 ; i <= n ; i++)
			sum += freq[i] ;
		fin.close();
	}

	int check(int index, vector<char> sol){
		for(int j = 0 ; j < k + 1 ; j++)
			if(sol[sol.size() - j - 1] != caractere[index])
				return 1;
		return 0;
	}

	void bkt(int n, int sum, int k, int step, vector<char> sol){
		if(sum == step){
			all.push_back(sol) ;
		}
		else
			for(int i = 1 ; i <= caractere.size(); i++)
				if(freq[i] > 0 && check(i, sol)){
					freq[i]-- ;
					bkt(n, sum, k, step + 1, sol) ;
					freq[i]++ ;
				}
	}

	vector<vector<char> > get_result() {
		vector<int> sol ;

		bkt(n, sum, k, 0, sol) ;
		/*
		TODO: Construiti toate sirurile cu caracterele in stringul caractere
		(indexat de la 1 la n), si frecventele in vectorul freq (indexat de la
		1 la n), stiind ca nu pot fi mai mult de K aparitii consecutive ale
		aceluiasi caracter.

		Pentru a adauga un nou sir:
			vector<char> sir;
			all.push_back(sir);
		*/

		return all;
	}

	void print_output(vector<vector<char> > result) {
		ofstream fout("out");
		fout << result.size() << '\n';
		for (int i = 0; i < (int)result.size(); i++) {
			for (int j = 0; j < (int)result[i].size(); j++) {
				fout << result[i][j];
			}
			fout << '\n';
		}
		fout.close();
	}
};

int main() {
	Task task;
	task.solve();
	return 0;
}
