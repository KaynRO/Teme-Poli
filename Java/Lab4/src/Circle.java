import javax.swing.text.MutableAttributeSet;

public class Circle extends GeometricObject {
    double Radius ;

    public Circle(String color, boolean filled ,double Radius){
        super(color, filled) ;
        this.Radius = Radius ;
    }

    public double getArea(){
        return Math.PI * this.Radius * this.Radius ;
    }

    public double getPerimeter(){
        return Math.PI * 2 * this.Radius ;
    }

    @Override
    public void display(){
        System.out.println("Circle displayed of radius: " + this.Radius);
    }
}
