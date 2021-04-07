#include <fstream>
#include <vector>
#include <algorithm>
#include <iostream>
#include <queue>
using namespace std;

const int kNmax = 100005;

class Task {
 public:
	void solve() {
		read_input();
		print_output(get_result());
	}

 private:
	int n, m, source, dist[kNmax] ;
	bool vis[kNmax] ;
	vector<int> adj[kNmax];
	vector<int> d;
	queue<int> Q ;

	void read_input() {
		ifstream fin("in");
		fin >> n >> m >> source;
		for (int i = 1, x, y; i <= m; i++) {
			fin >> x >> y;
			adj[x].push_back(y);
			adj[y].push_back(x);
		}
		fin.close();
	}

	void bfs(int node){

		for(int i = 1 ; i <= n ; i++)
			dist[i] = -1 ;

		dist[node] = 0 ;
		Q.push(node) ;

		while(!Q.empty()){
			int current = Q.front() ;
			Q.pop() ;

			for(vector<int> :: iterator it = adj[current].begin() ; it != adj[current].end(); ++it){
				if(dist[*it] != -1)
					continue ;
				dist[*it] = dist[current] + 1 ;
				Q.push(*it) ;
			}
		}
	}

	vector<int> get_result() {
		/*
		TODO: Faceti un BFS care sa construiasca in d valorile d[i] = numarul
		minim de muchii de parcurs de la nodul source la nodul i.
		d[source] = 0
		d[x] = -1 daca nu exista drum de la source la x.
		*******
		ATENTIE: nodurile sunt indexate de la 1 la n.
		*******
		*/
		bfs(source) ;
		for(int i = 1 ; i <= n ; i++){
			d.push_back(dist[i]) ;
			cout << dist[i] << ' ' ;
		}
		return d;
	}

	void print_output(vector<int> result) {
		ofstream fout("out");
		for (int i = 0; i < n; i++) {
			fout << result[i] << (i == n ? '\n' : ' ');
		}
		fout.close();
	}
};

int main() {
	Task *task = new Task();
	task->solve();
	delete task;
	return 0;
}
