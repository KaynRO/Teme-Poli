#include <iostream>
#include <algorithm>

using namespace std ;

int N , V[1000] , aux[1000] ;

int mmerge( int st , int dr )
{
		int i , j , k, m = ( st + dr ) / 2 , nr = 0 ;
		i = k = st ;
		j = m + 1 ;

		while ( i <= m && j <= dr )
		{
			if ( V[i] <= V[j] )
				aux[k++] = V[i++] ;
			else
			{
				aux[k++] = V[j++] ;
				nr += m - i + 1 ;
			}
		}

		while ( i <= m )
			aux[k++] = V[i++] ;
		while ( j <= dr )
			aux[k++] = V[j++] ;

		for ( k = st ; k <= dr ; k++ )
			V[k] = aux[k] ;

		return nr ;
}

int solve( int st , int dr )
{
	if ( st == dr )
		return 0 ;

	int mid = ( st + dr ) / 2 ;
	int inv = solve( st, mid ) ;
	inv += solve( mid + 1, dr ) ;
	inv += mmerge( st, dr ) ;
	return inv ;
}

int main()
{
	cin >> N ;
	for ( int i = 1 ; i <= N ; i++ )
		cin >> V[i] ;

	cout << solve(1, N) ;


}