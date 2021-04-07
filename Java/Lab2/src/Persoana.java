import java.util.ArrayList;

public class Persoana {
    public String nume ;

    public Persoana(){
    }

    public Persoana(String nume){
        this.nume = nume ;
    }
    public String toString(){
        return this.nume ;
    }

    public static void main(String[] args){
        Persoana persoana = new Persoana("Andrei") ;
        Profesor profesor = new Profesor("Ionescu","POO") ;
        Student student = new Student("Popescu", 10) ;
        Profesor profesor1 = new Profesor("Georgescu","PC") ;
        Student student1 = new Student("Gicu", 8) ;

        System.out.println(persoana.toString()) ;
        System.out.println(profesor.toString()) ;
        System.out.println(student.toString()) ;
        System.out.println("\n");

        ArrayList<Persoana> arrayList = new ArrayList<Persoana>(4) ;
        arrayList.add(persoana) ;
        arrayList.add(profesor1) ;
        arrayList.add(profesor) ;
        arrayList.add(student1) ;
        arrayList.add(student) ;

        for ( int i = 0 ; i < arrayList.size() ; i++ )
            System.out.println(arrayList.get(i) ) ;

        System.out.println("\n");

        for ( int i = 0 ; i < arrayList.size() ; i++ ) {
            if (arrayList.get(i) instanceof Student)
                ((Student) arrayList.get(i)).invata();
            if (arrayList.get(i) instanceof Profesor)
                ((Profesor) arrayList.get(i)).preda();
        }
    }
}
