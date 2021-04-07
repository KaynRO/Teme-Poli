#include <iostream>
#include <queue>
#include <utility>
#include <algorithm>

#define NMAX 10000

using namespace std ;

int N, startX, startY , M[NMAX][NMAX] , dist[NMAX][NMAX] , dX, dY ;
int dl[] = {1, -1, 0 , 0} ;
int dc[] = {0, 0, 1, -1} ;
bool vis[NMAX][NMAX] ;
queue<pair<int, int>> Q ;
vector<pair<int, int>> sol ;

int check(int x, int y){
	if( x >= 1 && x <= N && y >= 1 && y <= N && (M[x][y] == 0 || M[x][y] == 2))
		return 1 ;
	return 0 ;
}

int bfs(int x , int y){

	dist[x][y] = 0 ;
	vis[x][y] = 0 ;
	Q.push(make_pair(x, y)) ;

	while(!Q.empty()){
		int cX = Q.front().first ;
		int cY = Q.front().second ;
		Q.pop() ;
		vis[cX][cY] = 0 ;

		for(int i = 0 ; i < 5 ; i++)
			if(check(cX + dl[i], cY + dc[i]) && dist[cX][cY] + 1 < dist[cX + dl[i]][cY + dc[i]]){
				dist[cX + dl[i]][cY + dc[i]] = dist[cX][cY] + 1 ;
				if(M[cX + dl[i]][cY + dc[i]] == 2){
					dX = cX + dl[i] ;
					dY = cY + dc[i] ;
					return dist[cX + dl[i]][cY + dc[i]] ;
				}

				if(vis[cX + dl[i]][cY + dc[i]] == 0)
					vis[cX + dl[i]][cY + dc[i]], Q.push(make_pair(cX + dl[i], cY + dc[i])) ;
			}
	}

	return -1 ;
}

void make_path(){
	sol.push_back(make_pair(dX, dY)) ;

	int x = dX, y = dY ;
	while(x != startX && y != startY){
		for(int i = 0 ; i < 5 ; i++)
			if(check(x + dl[i], y + dc[i]) && M[x + dl[i]][y + dc[i]] == 0 && dist[x + dl[i]][y + dc[i]] + 1 == dist[x][y]){
				sol.push_back(make_pair(x + dl[i], y + dc[i])) ;
				x = x + dl[i] ;
				y = y + dc[i] ;
				break ;
			}
	}

	sol.push_back(make_pair(startX, startY)) ;
	reverse(sol.begin() , sol.end()) ;
}


int main(){
	
	cin >> N >> startX >> startY ;
	for(int i = 1 ; i <= N ; i++)
		for(int j = 1 ; j <= N ; j++)
			cin >> M[i][j] , dist[i][j] = NMAX ;

	cout << bfs(startX, startY) << '\n' ;

	make_path() ;

	for(int i = 0 ; i < sol.size() ; i++)
		cout << sol[i].first << ' ' << sol[i].second << '\n' ;
}