#include <fstream>
#include <vector>
#include <algorithm>
#include <iostream>
using namespace std;

struct Homework {
	int deadline;
	int score;

	Homework(int _deadline, int _score) : deadline(_deadline), score(_score) {}
};

class Task {
 public:
	void solve() {
		read_input();
		print_output(get_result());
	}

	struct Comparator{
		bool operator()(const Homework& A, const Homework& B)const{
			return A.score > B.score ;
		}
	};

 private:
	int n ;
	vector<Homework> hws;
	vector<int> weeks;

	void read_input() {
		ifstream fin("in");
		fin >> n;
		for (int i = 0, deadline, score; i < n; i++) {
			fin >> deadline >> score;
			weeks.push_back(-1);
			hws.push_back(Homework(deadline, score));
		}
		fin.close();
	}

	int get_result() {
		/*
		TODO: Aflati punctajul maxim pe care il puteti obtine planificand
		optim temele.
		*/

		int score = 0 ;
		sort(hws.begin(), hws.end(), Comparator()) ;

		for(int i = 0 ; i < n ; i++)
			for(int j = hws[i].deadline - 1 ; j >= 0 ; j--)
				if(weeks[j] == -1)
				{
					weeks[j] = i ;
					score += hws[i].score ;
					break ;
				}


		return score ;
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