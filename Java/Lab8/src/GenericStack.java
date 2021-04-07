import java.util.ArrayList;

public class GenericStack<E> {
    public ArrayList<E> list = new ArrayList<E>();

    public int getSize() {
        return list.size();
    }

    public void push(E o) {
        list.add(o);
    }

    public E peek() {
        return list.get(list.size() - 1);
    }

    public E pop() {
        E o = peek();
        list.remove(list.size() - 1);
        return o;
    }

    public boolean isEmpty() {
        return list.isEmpty();
    }

    public static <E> void printStack(GenericStack<E> st) {
        System.out.println("Stack elements are: ");
        for (E o : st.list) {
            System.out.print(o + " ");
        }
        System.out.println();
    }

    public static <E extends Comparable<E>> int binarySearch(E[] list, E key) {
        int st = 0;
        int dr = list.length - 1;
        while (st <= dr) {
            int mid = (st + dr) / 2;
            if (key.compareTo(list[mid]) < 0)
                st = mid + 1;
            else if (key.compareTo(list[mid]) > 0)
                dr = mid - 1;
            else if (key.compareTo(list[mid]) == 0)
                return mid;
        }
        return st;
    }

    public static <E extends Comparable<E>> E max(E[] list) {
        E max = list[0] ;
        for ( E o : list){
            if(o.compareTo(max) > 0 )
                max = o ;
        }
        return max ;
    }

    public static void main(String[] args) {
        GenericStack<Integer> integer = new GenericStack<Integer>();
        GenericStack<Double> ddouble = new GenericStack<Double>();
        GenericStack<String> string = new GenericStack<String>();

        integer.push(1);
        integer.push(2);
        integer.push(3);
        ddouble.push(3.5);
        ddouble.push(4.5);
        ddouble.push(5.5);
        string.push("ana");
        string.push("are");
        string.push("mere");

        GenericStack.printStack(integer);
        GenericStack.printStack(ddouble);
        GenericStack.printStack(string);

        Integer[] list = new Integer[integer.getSize()];

        for (int i = 0; i < integer.getSize(); i++) {
            list[i] = integer.list.get(i);
        }

        System.out.println(GenericStack.binarySearch(list, new Integer(2)));
        System.out.println(GenericStack.max(list));
    }
}
