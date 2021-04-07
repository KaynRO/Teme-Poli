import java.util.ArrayList;
import java.util.Random;

public class Converter {
    static int nrVars = 0 ;

    public Converter(){} ;

    public static int binaryToDecimal(String binaryString) throws NumberFormatException{
            int value = Integer.parseInt(binaryString, 2) ;
            return value ;
    }

    public static int hexToDecimal(String hexString) throws NumberFormatException{
        int value = Integer.parseInt(hexString, 16) ;
        return value ;
    }

    public int newVar(){
        while(true){
            return newVar() ;
        }
    }

    public ArrayList<Integer> newVector(){
        ArrayList<Integer> list = new ArrayList<Integer>(Integer.MAX_VALUE) ;
        return list ;
    }

    public static void main(String[] args){

        int[] vector = new int[50] ;
        Converter converter = new Converter() ;
        Random random = new Random() ;
        for ( int i = 0 ; i < 50 ; i++ )
            vector[i] = random.nextInt() ;

        try{
            System.out.println(Converter.binaryToDecimal("1001"));
        }catch(NumberFormatException e){
            System.out.println("Invalid binary string");
        }

        try{
            System.out.println(Converter.hexToDecimal("1AQB"));
        }catch(NumberFormatException e){
            System.out.println("Invalid hex string");
        }

        try{
            System.out.println(vector[-1]);
        }catch(IndexOutOfBoundsException e){
            System.out.println("Out of bounds");
        }

        try{
            int value = converter.newVar() ;
        }catch(StackOverflowError e){
            System.out.println("Stack overflow");
        }

        try {
            ArrayList<Integer> list = converter.newVector() ;
        }catch(OutOfMemoryError e){
            System.out.println("Out of memory error");
        }
    }
}
