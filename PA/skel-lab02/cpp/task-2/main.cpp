#include <fstream>
#include <vector>
using namespace std;

class Task {
 public:
	void solve() {
		read_input();
		print_output(get_result());
	}

 private:
	int n, m;
	vector<int> dist;

	void read_input() {
		ifstream fin("in");
		fin >> n >> m;
		for (int i = 0, d; i < n; i++) {
			fin >> d;
			dist.push_back(d);
		}
		fin.close();
	}

	int getDist(int i , int j)
	{
		if(i == 0)
			return dist[j] ;
		return dist[j] - dist[i] ;
	}

	int get_result() {
		/*
		TODO: Aflati numarul minim de opriri necesare pentru a ajunge
		la destinatie.
		*/

		int fuel = m , current = 0 , stops = 0 ;

		while(current != n)
		{
			int toDo = getDist(current, current + 1) ;
			if(fuel < toDo)
				stops++ , fuel = m ;
			current++, fuel -= toDo ;
		}

		return stops ;
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