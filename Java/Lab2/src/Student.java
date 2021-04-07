public class Student extends Persoana {
    public int nota;

    public Student() {
    }

    public Student(String nume , int nota) {
        this.nota = nota;
        this.nume = nume ;
    }

    @Override
    public String toString() {
        return "Student: " + super.toString() + ", " + this.nota;
    }

    public void invata(){
        System.out.println(super.toString() + " invata" ) ;
    }
}
