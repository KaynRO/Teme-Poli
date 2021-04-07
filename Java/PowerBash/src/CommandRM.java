import java.util.ArrayList;

//Convert from path to a node in the filesystem. Check for errors. Let the filesystem remove the node
class CommandRM extends Command {
    private ArrayList<String> arguments;

    CommandRM(ArrayList<String> arguments) {
        this.arguments = arguments;
    }

    public ResultCollector execute() {

        ResultCollector resultCollector = new ResultCollector();
        String pathSource;

        if (arguments.get(0).contains("/"))
            pathSource = arguments.get(0).substring(0, arguments.get(0).lastIndexOf("/"));
        else pathSource = "";

        String nameSource = arguments.get(0).substring(arguments.get(0).lastIndexOf("/") + 1);
        Node source = pathToNode(pathSource, arguments.get(0));

        if (source != null && source.contains(nameSource)) {
            for (Node aux : source.getContent())
                if (aux.getDataName().equals(nameSource))
                    source = aux;

            if (source.getDataName().equals(fileSystem.getCurrentDirectory().getDataName()))
                return resultCollector;
            fileSystem.rm(source);
        } else
            resultCollector.setError("rm: cannot remove " + arguments.get(0) + ": No such file or directory");
        return resultCollector;
    }
}
