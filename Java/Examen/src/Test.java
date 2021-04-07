import java.util.*;


public class Test<E extends Object>{
    E Test ;
    public Test(E Test){
        this.Test = Test ;
    }

    public E getTest(){
        return Test ;
    }


    public static void main(String[] args){
        Test<Test> Test1 = new Test(42) ;
        Test Test2 = new Test<Test>(Test1.getTest()) ;
        Test Test3 = Test1.getTest() ;

    }
}
