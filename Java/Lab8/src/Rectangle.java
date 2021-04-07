public class Rectangle extends GeometricObject {
    double width;
    double height;

    public Rectangle(double width , double height){
        this.height = height ;
        this.width = width ;
    }

    @Override
    public double getArea() {
        return width * height;
    }

    @Override
    public void display() {
        System.out.println("Rectangle sides are " + width + " and " + height);
    }
}
