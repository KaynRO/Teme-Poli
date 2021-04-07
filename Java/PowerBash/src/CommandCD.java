import java.util.ArrayList;

//Convert from path to a node in the filesystem. Check for errors. Let the filesystem change the directory
class CommandCD extends Command {
    private ArrayList<String> arguments;

    CommandCD(ArrayList<String> arguments) {
        this.arguments = arguments;
    }

    ResultCollector execute() {

        ResultCollector resultCollector = new ResultCollector();
        Node node = pathToNode(arguments.get(0), arguments.get(0));

        if (node == null)
            resultCollector.setError("cd: " + arguments.get(0) + ": No such directory");
        else fileSystem.cd(node);

        return resultCollector;

    }
}
