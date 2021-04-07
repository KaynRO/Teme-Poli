package arrays;
import java.util.*;

public class MyArrayList {

    public int[] vector ;
    public int nrElem = 0 ;

    public MyArrayList(){
        this.vector = new int[10] ;
    }

    public MyArrayList(int dimension){
        this.vector = new int[dimension] ;
    }

    public void add(int value){
        if(this.nrElem == this.vector.length ) {

            int[] aux = new int[2 * this.nrElem] ;
            System.arraycopy(aux, 0, vector, 0, this.nrElem) ;
            this.vector = aux ;
        }
            this.vector[nrElem++] = value ;
    }

    public int size(){
        return this.vector.length ;
    }

    public int get(int index){
        return this.vector[index - 1] ;
    }

    public static void main(String[] args){
        MyArrayList array = new MyArrayList(5) ;
        Random generator = new Random() ;

        array.add(generator.nextInt()) ;
        array.add(generator.nextInt()) ;
        array.add(generator.nextInt()) ;
        array.add(generator.nextInt()) ;
        array.add(generator.nextInt()) ;
        array.add(generator.nextInt()) ;
        //array.add(generator.nextInt()) ;
        //array.add(generator.nextInt()) ;
        //array.add(generator.nextInt()) ;
        //array.add(generator.nextInt()) ;

        System.out.println(array.nrElem + " : " + array.size() ) ;
    }
}
