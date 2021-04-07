import java.io.File;
import java.io.PrintWriter;
import java.util.ArrayList;

//Class that manages all commands and write results after finishing them
class CommandManager {
    private static ArrayList<ResultCollector> results = new ArrayList<>();

    static void execute(Command command) {
        results.add(command.execute());
    }

    static void writeResults() {
        try {
            for (int i = 0; i < results.size(); i++) {
                if (i == 0) {
                    PrintWriter writer = new PrintWriter(new File(Main.outputFile));
                    writer.print("");
                    writer.close();

                    writer = new PrintWriter(new File(Main.errorFile));
                    writer.print("");
                    writer.close();
                }
                results.get(i).setIndex(i + 1);
                results.get(i).writeResults();
            }
        } catch (Exception e) {
            System.out.println("Error while opening file");
        }
    }
}
