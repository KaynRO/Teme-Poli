import java.io.File;
import java.io.FileWriter;
import java.util.*;

// Main class where we read data from file, parse is as necessary and then execute the command.
public class Tema2 {

    public static void main(String[] args) {
        try {
            File filename = new File(args[0]);
            File outputFile = new File(args[0] + "_out");
            FileWriter writer = new FileWriter(outputFile);
            Scanner scanner = new Scanner(filename);
            Database myDB = new Database();

            while (scanner.hasNextLine()) {
                String command = scanner.nextLine();
                List<String> words = Arrays.asList(command.split(" "));

                if (words.get(0).equals("CREATEDB")) {
                    myDB = new Database(Integer.parseInt(words.get(2)), Integer.parseInt(words.get(3)));
                }
                if (words.get(0).equals("CREATE")) {
                    ArrayList<String> attributeNames = new ArrayList<>();
                    ArrayList<String> attributeTypes = new ArrayList<>();
                    for (int i = 0; i < Integer.parseInt(words.get(3)); i++) {
                        attributeNames.add(words.get(4 + i * 2));
                        attributeTypes.add(words.get(4 + i * 2 + 1));
                    }
                    myDB.createEntry(words.get(1), Integer.parseInt(words.get(2)), attributeNames, attributeTypes);
                }
                if (words.get(0).equals("INSERT")) {
                    ArrayList<String> attributeValues = new ArrayList<>();
                    for (int i = 0; i < myDB.getEntrySize(words.get(1)); i++) {
                        Collections.addAll(attributeValues, words.get(2 + i));
                    }
                    myDB.insert(words.get(1), attributeValues);
                }
                if (words.get(0).equals("SNAPSHOTDB")) {
                    myDB.snapshotDB(writer);
                }
                if (words.get(0).equals("GET")) {
                    myDB.print(words.get(1), words.get(2), writer);
                }
                if (words.get(0).equals("DELETE")) {
                    myDB.delete(words.get(1), words.get(2), writer);
                }
                if (words.get(0).equals("UPDATE")) {
                    ArrayList<String> attributeNames = new ArrayList<>();
                    ArrayList<String> attributeValues = new ArrayList<>();
                    for (int i = 0; i < (words.size() - 3) / 2; i++) {
                        attributeNames.add(words.get(3 + i * 2));
                        attributeValues.add(words.get(3 + i * 2 + 1));
                    }
                    myDB.update(words.get(1), words.get(2), attributeNames, attributeValues);
                }
                if (words.get(0).equals("CLEANUP")) {
                    myDB.clean(Long.parseLong(words.get(2)));
                }
            }
            writer.close();
        } catch (Exception e) {
            System.out.println("Something went wrong");
            e.printStackTrace();
        }
    }
}