import java.util.*;

public class StudentMap {
    SortedMap<Integer, List<Student>> map = new TreeMap<>(new Comparator<>() {
        public int compare(Integer a, Integer b) {
            return -1 * a.compareTo(b);
        }
    });

    StudentMap() {
    }

    void add(Student a) {
        int medie = (int) Math.round(a.medie);
        if (map.containsKey(medie))
            map.get(medie).add(a);
        else {
            List<Student> list = new ArrayList<>();
            list.add(a);
            map.put(medie, list);
        }
    }

    public static void main(String[] args) {
        StudentMap smap = new StudentMap();
        smap.add(new Student("Andrei", 3.5));
        smap.add(new Student("George", 9.8));
        smap.add(new Student("Mihai", 7.8));
        smap.add(new Student("Daniel", 2.1));
        smap.add(new Student("Andrei", 2.1));


        for (SortedMap.Entry<Integer, List<Student>> entry : smap.map.entrySet()) {
            Collections.sort(entry.getValue());
            System.out.println(entry.getKey() + " " + entry.getValue());
        }

    }

}