import java.util.ArrayList;

//Convert from path to a node in the filesystem. Check for errors. Let the filesystem create the noe
class CommandMKDIR extends Command {
    private ArrayList<String> arguments;

    CommandMKDIR(ArrayList<String> arguments) {
        this.arguments = arguments;
    }

    public ResultCollector execute() {

        ResultCollector resultCollector = new ResultCollector();
        boolean ok = true;
        String path;

        if (arguments.get(0).contains("/"))
            path = arguments.get(0).substring(0, arguments.get(0).lastIndexOf("/"));
        else path = "";

        String name = arguments.get(0).substring(arguments.get(0).lastIndexOf("/") + 1);
        Node node = pathToNode(path, arguments.get(0));

        if (node == null)
            resultCollector.setError("mkdir: " + path + ": No such directory");
        else {
            for (Node aux : node.getContent())
                if (aux.getDataName().equals(name)) {
                    resultCollector.setError("mkdir: cannot create directory " + fileSystem.pwd(aux) + ": Node exists");
                    ok = false;
                }

            if (ok)
                fileSystem.mkdir(node, name);
        }
        return resultCollector;
    }
}
