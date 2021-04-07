import java.util.ArrayList;

//Convert from path to a node in the filesystem. Check for errors. Let the filesystem print the content
class CommandLS extends Command {
    private ArrayList<String> arguments;

    CommandLS(ArrayList<String> arguments) {
        this.arguments = arguments;
    }

    public ResultCollector execute() {

        ResultCollector resultCollector = new ResultCollector();

        if (arguments.size() == 0)
            resultCollector.setOutput(fileSystem.ls(fileSystem.getCurrentDirectory(), 0, new StringBuilder()));
        else if (arguments.size() == 1 && arguments.get(0).equals("-R")) {
            resultCollector.setOutput(fileSystem.ls(fileSystem.getCurrentDirectory(), 1, new StringBuilder()));
        } else {
            String name = "";
            if (arguments.size() == 1)
                name = arguments.get(0);
            if (arguments.size() == 2 && arguments.get(0).equals("-R"))
                name = arguments.get(1);
            if (arguments.size() == 2 && arguments.get(1).equals("-R"))
                name = arguments.get(0);

            Node node = pathToNode(name, name);

            if (node == null)
                resultCollector.setError("ls: " + name + ": No such directory");
            else
                resultCollector.setOutput(fileSystem.ls(node, arguments.size() == 2 ? 1 : 0, new StringBuilder()));
        }

        return resultCollector;
    }
}
