import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintWriter;

//Class that collects results after a command is executed and than print the output
class ResultCollector {
    private int index;
    private String output = "";
    private String error = "";

    ResultCollector() {
    }

    void setOutput(String output) {
        this.output = output;
    }

    void setError(String error) {
        this.error = error;
    }

    void setIndex(int index) {
        this.index = index;
    }

    //Open error and output file in append mode and write results
    void writeResults() {
        try {
            PrintWriter printWriter = new PrintWriter(new FileOutputStream(new File(Main.outputFile), true));
            printWriter.write(index + "\n");
            if (!output.equals(""))
                printWriter.write(output);
            printWriter.close();

            printWriter = new PrintWriter(new FileOutputStream(new File(Main.errorFile), true));
            printWriter.write(index + "\n");
            if (!error.equals(""))
                printWriter.write(error + "\n");
            printWriter.close();
        } catch (Exception e) {
            System.out.println("Error while writing results");
        }
    }
}
