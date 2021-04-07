import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

class Main {

    static String outputFile;
    static String errorFile;

    public static void main(String args[]) {

        String inputFile;

        //Declare all parameter filenames
        inputFile = args[0];
        outputFile = args[1];
        errorFile = args[2];

        //Read every line from input, and get a command instance for it
        try {

            BufferedReader buffer = new BufferedReader(new FileReader(new File(inputFile)));

            for (String line; (line = buffer.readLine()) != null; ) {

                //Split a line by token " "
                String[] lineFeed = line.split(" ");
                ArrayList<String> arguments = new ArrayList<>(Arrays.asList(Arrays.copyOfRange(lineFeed, 1, lineFeed.length)));

                //Get a new instace of command and queue it to the execution manager class
                CommandManager.execute(CommandFactory.getInstance().getCommand(lineFeed[0], arguments));
            }

            //When all commands are finished, write the results
            CommandManager.writeResults();

        } catch (IOException e) {
            System.out.println("File error");
        }


    }
}
