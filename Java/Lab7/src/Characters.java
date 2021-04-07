import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.util.Scanner;

public class Characters {

    public static void countFrequency() {

        int[] frequency = new int[120];
        Scanner scanner = new Scanner(System.in);

        String input = scanner.nextLine();
        input = input.toLowerCase();
        for (int i = 0; i < input.length(); i++) {
            frequency[input.charAt(i) - 'a']++;
        }

        for (int i = 0; i < 30; i++) {
            if (frequency[i] != 0)
                System.out.println("Character " + ((char) (i + 97)) + " appeared " + frequency[i] + " times\n");
        }
    }

    public static void maxFrequency() {
        Scanner scanner = new Scanner(System.in);
        String filename = scanner.nextLine();

        try {
            scanner = new Scanner(new File(filename));
        } catch (Exception e) {
            System.out.println("File not found");
            System.exit(1);
        }

        String line = scanner.nextLine();
        int[] frequency = new int[120];

        for (int i = 0; i < line.length(); i++) {
            frequency[line.charAt(i) - 'A']++;
        }

        int max = 0;
        for (int i = 0; i < 120; i++) {
            if (frequency[i] != 0 && frequency[i] > frequency[max])
                max = i;
        }

        System.out.println("Most written character is " + ((char) (max + 65)));

    }

    public static void copyFile(String[] args) throws Exception {
        File sourceFile = sourceFile = new File(args[0]);
        File destFile = destFile = new File(args[1]);

        FileInputStream fileSource = new FileInputStream(sourceFile);
        FileOutputStream fileDest = new FileOutputStream(destFile);

        byte[] buffer = new byte[1024];
        int n;
        while ((n = fileSource.read(buffer)) != -1) {
            fileDest.write(buffer, 0, n);
        }
        fileDest.close();
        System.out.println(destFile.length() + " bytes copied\n" );
    }

    public static void noWords(String[] args) throws Exception{
        File file = new File(args[0]) ;
        Scanner scanner = new Scanner(file) ;

        String line = scanner.nextLine() ;
        String[] words = line.split("[. ]+") ;
        System.out.println("The file has " + words.length + " words\n" );
    }

    public static void replace() throws Exception{
        Scanner scanner = new Scanner(System.in) ;
        String word1 = scanner.nextLine() ;
        String word2 = scanner.nextLine() ;
        File filename = new File(scanner.nextLine()) ;

        String fileContent = new Scanner(filename).useDelimiter("\\Z").next() ;
        String newContent = fileContent.replace(word1, word2) ;
        FileWriter file = new FileWriter(filename) ;
        file.write(newContent) ;
        file.close() ;
    }

    public static void main(String[] args) {
        Characters.countFrequency();
        Characters.maxFrequency();
        try {
            Characters.copyFile(args);
        } catch (Exception e) {
            System.out.println("IO Exception");
        }

        try{
            Characters.noWords(args);
        }catch (Exception e){
            System.out.println("IO Exception");
        }

        try{
            Characters.replace();
        }catch(Exception e){
            System.out.println("IO Exception");
        }
    }
}
