import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;

public class Scene {
    GeometricObject[] array ;
    int idx = 0 ;

    public Scene(int dimension){
        array = new GeometricObject[dimension] ;
    }

    public void add(GeometricObject o){
        this.array[idx++] = o ;
    }

    public void displayAll(){
        for ( GeometricObject o : this.array ){
            o.display();
        }
    }

    public double areaAll(){
        double areaAll = 0 ;
        for ( GeometricObject o : this.array ){
            areaAll += o.getArea() ;
        }
        return areaAll ;
    }

    public double perimeterAll(){
        double perimeterAll = 0 ;
        for ( GeometricObject o : this.array ){
            perimeterAll += o.getPerimeter() ;
        }
        return perimeterAll ;
    }

    public void sort(){
        Arrays.sort(this.array, 0, this.idx);
    }

    public static void main(String[] args){
        Circle circleA = new Circle("black", false, 1) ;
        Circle circleB = new Circle("black", false, 2) ;

        Rectangle rectangleA = new Rectangle("black", false, 2, 3) ;
        Rectangle rectangleB = new Rectangle("black", false, 4, 5) ;

        Scene myScene = new Scene(4) ;
        myScene.add(circleA) ;
        myScene.add(circleB) ;
        myScene.add(rectangleA) ;
        myScene.add(rectangleB) ;
        myScene.displayAll() ;
        myScene.areaAll() ;
        myScene.perimeterAll() ;

        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        for ( GeometricObject o : myScene.array ){
            System.out.println(dateFormat.format(o.getDateCreated()));
        }

    }

}
