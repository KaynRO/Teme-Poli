public class Circle extends GeometricObject {

    double radius ;

    public Circle(double radius){
        this.radius = radius ;
    }

    @Override
    public double getArea() {
        return 2 * Math.PI * radius ;
    }

    @Override
    public void display() {
        System.out.println("Circle radius is " + radius );
    }
}
