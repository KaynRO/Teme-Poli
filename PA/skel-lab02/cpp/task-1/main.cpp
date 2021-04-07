#include <fstream>
#include <iomanip>
#include <vector>
#include <iostream>
#include <algorithm>

using namespace std ;

struct Object {
	int weight;
	int price;

	Object(int _weight, int _price) : weight(_weight), price(_price) {}
};

class Task {
 public:
	void solve() {
		read_input();
		print_output(get_result());
	}

 private:
	int n, w;
	vector<Object> objs;

	struct Comparator{
		bool operator()(const Object& A, const Object& B) const
		{
			return ((double)A.price / (double)A.weight) > ((double)B.price / (double)B.weight) ;
		}
	};

	void read_input() {
		ifstream fin("in");
		fin >> n >> w;
		for (int i = 0, weight, price; i < n; i++) {
			fin >> weight >> price;
			objs.push_back(Object(weight, price));
		}
		fin.close();
	}

	double get_result() {
		/*
		TODO: Aflati profitul maxim care se poate obtine cu obiectele date.
		*/

		double profit = 0 ;
		int index = 0 ;
		sort(objs.begin() , objs.end(), Comparator()) ;

		while(w > 0)
		{
			Object elem = objs[index] ;

			if(w >= elem.weight)
			{
				w -= elem.weight ;
				profit += elem.price ;
				index++ ;
			}
			else 
			{
				profit += (((double)w / (double)elem.weight) * (double)elem.price) ;
				w = 0 ;
			}
		}


		return profit ;
	}

	void print_output(double result) {
		ofstream fout("out");
		fout << setprecision(4) << fixed << result;
		fout.close();
	}
};

int main() {
	Task task;
	task.solve();
	return 0;
}