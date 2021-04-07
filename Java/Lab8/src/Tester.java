import java.util.ArrayList;

public class Tester {
    public static void main(String[] args) {
        Square a = new Square(2);
        Rectangle b = new Rectangle(2, 3);
        Circle c = new Circle(0.2);

        ArrayList<GeometricObject> list = new ArrayList<GeometricObject>();
        list.add(a);
        list.add(b);
        list.add(c);

        GeometricObject.maximumArea(list);

        GeometricObject[] list2 = new GeometricObject[list.size()];
        for (int i = 0; i < list.size(); i++)
            list2[i] = list.get(i);
        GeometricObject.seletionSort(list2);
    }
}
