import java.util.Date;

public abstract class GeometricObject implements Comparable {
    String color ;
    boolean filled ;
    Date dateCreated ;

    public GeometricObject(){
        this.color = "red" ;
        this.filled = false ;
        this.dateCreated = new Date() ;
    }

    public GeometricObject(String color , boolean filled){
        this.color = color ;
        this.filled = filled ;
        this.dateCreated = new Date() ;

    }

    public String getColor(){
        return this.color ;
    }

    public void setColor(String color){
        this.color = color ;
    }

    public boolean isFilled(){
        return this.filled ;
    }

    public void setFilled(boolean filled){
        this.filled = filled ;
    }

    public Date getDateCreated(){
        return this.dateCreated ;
    }

    public abstract double getArea() ;
    public abstract double getPerimeter() ;
    public abstract void display() ;

    public int compareTo(Object o){
        if ( this.getPerimeter() > ((GeometricObject)o).getPerimeter() )
            return 1 ;
        if ( this.getPerimeter() == ((GeometricObject)o).getPerimeter() )
            return 0 ;
        return -1 ;
    }
}
