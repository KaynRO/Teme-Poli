import java.util.PriorityQueue;

public class Patient implements Comparable<Patient> {
    String name;
    int priority;

    public Patient(String name, int priority) {
        this.name = name;
        this.priority = priority;
    }

    @Override
    public int compareTo(Patient patient) {
        if (priority > patient.priority)
            return -1;
        if (priority < patient.priority)
            return 1;
        return 0;
    }

    public String toString(){
        return this.name + " " + this.priority ;
    }

    public static void main(String[] args) {
        PriorityQueue<Patient> queue = new PriorityQueue<>();
        queue.add(new Patient("Andrei", 1)) ;
        queue.add(new Patient("Daniel", 8)) ;
        queue.add(new Patient("Mihai", 6)) ;
        queue.add(new Patient("Luca", 2)) ;
        queue.add(new Patient("Ioan", 4)) ;

        while(!queue.isEmpty())
            System.out.println(queue.poll());

    }

}
