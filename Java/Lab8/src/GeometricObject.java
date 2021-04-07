import java.util.ArrayList;

public abstract class GeometricObject implements Comparable<GeometricObject> {

    public abstract double getArea();

    public void display() {
    }

    public int compareTo(GeometricObject o) {
        if (this.getArea() > o.getArea())
            return 1;
        if (this.getArea() < o.getArea())
            return -1;
        return 0;
    }

    public static void maximumArea(ArrayList<? extends GeometricObject> list) {
        GeometricObject o = list.get(1);
        for (GeometricObject aux : list)
            if ((aux).compareTo(o) > 0)
                o = aux;
        o.display();
    }

    public static <E extends Comparable<E>> void seletionSort(E[] list) {
        int index;
        for (int i = 0; i < list.length - 1; i++) {
            index = i;
            for (int j = i + 1; j < list.length; j++)
                if (list[j].compareTo(list[index]) < 0)
                    index = j;
            E aux = list[i];
            list[i] = list[index];
            list[index] = aux;
        }
        for (E aux : list) {
            ((GeometricObject)aux).display() ;
        }
    }
}
