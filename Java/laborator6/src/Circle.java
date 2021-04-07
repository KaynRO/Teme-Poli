import java.util.Random;

public class Circle {
    double radius;
    static int number = 0;

    void setRadius(double radius) throws InvalidRadiusException {
        if (radius < 0)
            throw new InvalidRadiusException();
        this.radius = radius;
    }

    public Circle(double radius) throws InvalidRadiusException {
        setRadius(radius);
        this.number++;
    }

    public static void main(String[] args) {
        try {
            Circle c1 = new Circle(1);
        } catch (InvalidRadiusException e) {
        }

        try {
            Circle c2 = new Circle(-2);
        } catch (InvalidRadiusException e) {
        }

        try {
            Circle c3 = new Circle(2);
            System.out.println(c3.number);
        } catch (InvalidRadiusException e) {
        }
    }
}
