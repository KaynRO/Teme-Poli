import java.io.File;
import java.util.HashSet;
import java.util.Scanner;
import java.util.Set;

public class Tester {
    public static void main(String[] argv) {
        try {
            File filename = new File(argv[0]);
            String content = new Scanner(filename).useDelimiter("\\Z").next();
            String[] elements = content.split(",|\\.|\\ ");
            Set<String> mySet = new HashSet<>();

            for (String element : elements)
                mySet.add(element);

            for (String aux : mySet)
                System.out.print(aux + " ");
        } catch (Exception e) {
            System.out.println("Problems with file");
        }
    }
}
