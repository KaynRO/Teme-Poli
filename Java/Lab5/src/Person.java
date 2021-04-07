import java.util.Scanner;

public class Person {
    String name;
    String CNP;

    public Person() {
        Scanner scanner = new Scanner(System.in);
        name = scanner.nextLine();
        CNP = scanner.nextLine();
    }

    boolean verify() {
        class CheckPerson {
            boolean check() {
                if (Character.isUpperCase(Person.this.name.charAt(0)) && Person.this.CNP.length() == 13 && (Person.this.CNP.charAt(0) == '1' || Person.this.CNP.charAt(0) == '2'))
                    return true;
                return false;
            }
        }
        CheckPerson checker = new CheckPerson() ;
        return checker.check() ;
    }

    public static void main(String[] args) {
        Person a = new Person() ;
        Person b = new Person() ;
        System.out.println(a.verify());
        System.out.println(b.verify());
    }

}
