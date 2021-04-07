public class Octagon extends GeometricObject implements Cloneable {
    double latura ;

    public Octagon(String color, boolean filled, double latura){
        super(color, filled) ;
        this.latura = latura ;
    }

    public double getArea(){
        return ( 2 + 4 / Math.sqrt(2) ) * this.latura * this.latura ;
    }

    public double getPerimeter(){
        return 8 * this.latura ;
    }

    public void display(){
        System.out.println("Octagon side is : " + this.latura);
    }


    public static void main(String[] args) throws CloneNotSupportedException{
        Octagon octagonA = new Octagon("black", false, 5) ;
        Octagon octagonB = ((Octagon)(octagonA.clone())) ;
        System.out.println(octagonA);
        System.out.println(octagonB);
        System.out.println(octagonA.compareTo(octagonB)) ;
    }

}
