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
	int n, k;
	vector<vector<int> > all;

	void read_input() {
		ifstream fin("in");
		fin >> n >> k;
		fin.close();
	}

	void bkt(int n, int k, int step, vector<int> sol){
		if(step == k){
			all.push_back(sol) ;
			sol.clear() ;
		}
		else
			for(int i = 1 ; i <= n ; i++)
				if(find(sol.begin(), sol.end(), i) == sol.end()){
					sol.push_back(i) ;
					bkt(n, k, step + 1, sol) ;
					sol.erase(sol.end() - 1) ;
				}
	}

	vector<vector<int> > get_result() {
		vector<int> sol ;

		bkt(n, k, 0, sol) ;

		return all;
	}

	void print_output(vector<vector<int> > result) {
		ofstream fout("out");
		fout << result.size() << '\n';
		for (int i = 0; i < (int)result.size(); i++) {
			for (int j = 0; j < (int)result[i].size(); j++) {
				fout << result[i][j] <<
					(j + 1 != result[i].size() ? ' ' : '\n');
			}
		}
		fout.close();
	}
};

int main() {
	Task task;
	task.solve();
	return 0;
}
