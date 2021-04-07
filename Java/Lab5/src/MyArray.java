import java.util.ArrayList;

public class MyArray {
    public int[] array;

    public MyArray(int dimension) {
        array = new int[dimension];
        for (int i = 0; i < dimension; i++)
            array[i] = i;
    }

    void printForward() {
        ArrayIterator iter = new ArrayIterator();
        while (iter.hasNext()) {
            System.out.println(iter.next());
            iter.iterator = iter.nextIndex();
        }
    }

    void printBackward() {
        ArrayIterator iter = new ArrayIterator();
        iter.iterator = this.array.length;
        while (iter.hasPrevious()) {
            System.out.println(iter.previous());
            iter.iterator = iter.previousIndex();
        }
    }

    int firstMultiple(int k){
        ArrayIterator iter = new ArrayIterator() ;
        while(iter.hasNext()){
            if ( iter.next() % k == 0 && iter.next() > 0 )
                return iter.nextIndex() ;
            iter.iterator = iter.nextIndex() ;
        }
        return -1 ;
    }


    public class ArrayIterator {
        public int iterator = -1;

        boolean hasNext() {
            return iterator < MyArray.this.array.length - 1 ? true : false;
        }

        boolean hasPrevious() {
            return iterator > 1 ? true : false;
        }

        int next() {
            if (hasNext())
                return MyArray.this.array[iterator + 1];
            return -1;
        }

        int nextIndex() {
            if (hasNext())
                return iterator + 1;
            else return -1;
        }

        int previous() {
            if (hasPrevious())
                return MyArray.this.array[iterator - 1];
            else return -1;
        }

        int previousIndex() {
            if (hasPrevious())
                return iterator - 1;
            else return -1;
        }
    }

    public static void main(String[] args){
        MyArray array = new MyArray(10) ;
        array.printForward();
        array.printBackward();
        System.out.println(array.firstMultiple(3));
    }
}
