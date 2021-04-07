public class Rectangle extends GeometricObject {
    double width ;
    double height ;

    public Rectangle(String color, boolean filled, double width, double height){
        super(color, filled) ;
        this.width = width ;
        this.height = height ;
    }

    public double getArea(){
        return this.height * this.width ;
    }

    public double getPerimeter(){
        return 2 * ( this.height + this.width ) ;
    }

    @Override
    public void display(){
        System.out.println("Rectangle displayed of dimensions: " + this.width + " and " + this.height);
    }
}
