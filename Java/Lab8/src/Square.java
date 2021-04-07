
public class Square extends GeometricObject {
    double side;

    public Square(double side) {
        this.side = side;
    }

    @Override
    public double getArea() {
        return side * side;
    }

    @Override
    public void display() {
        System.out.println("Square side is " + side);
    }
}