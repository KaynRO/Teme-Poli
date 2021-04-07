import java.util.*;

public class Student implements Comparable<Student> {
    String nume;
    double medie;

    public Student(String nume, double medie) {
        this.nume = nume;
        this.medie = medie;
    }

    @Override
    public String toString() {
        return nume + " " + medie;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Student student = (Student) o;
        return Double.compare(student.medie, medie) == 0 &&
                Objects.equals(nume, student.nume);
    }

    @Override
    public int hashCode() {
        return Objects.hash(nume, medie);
    }

    @Override
    public int compareTo(Student a) {
        return nume.compareTo(a.nume);
    }

    public static void main(String[] args) {
        Set<Student> mySet = new HashSet<Student>();
        Student a1 = new Student("Andrei", 5.5);
        Student a2 = new Student("Mihai", 3.5);
        Student a3 = new Student("Andrei", 5.5);
        mySet.add(a1);
        mySet.add(a2);
        mySet.add(a3);

        for (Student aux : mySet)
            System.out.println(aux);
    }
}
