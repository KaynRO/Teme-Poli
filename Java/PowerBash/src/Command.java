//Template for all command types
abstract class Command {
    static FileSystem fileSystem = new FileSystem();

    ResultCollector execute() {
        return null;
    }

    //Based on a path we start from current working directory or root, go down based on path's elements untill we find a node.
    static Node pathToNode(String path, String wholePath) {

        Node node = null;
        boolean ok;

        if (!wholePath.substring(0, 1).equals("/")) {
            node = fileSystem.getCurrentDirectory();
        } else if (wholePath.substring(0, 1).equals("/"))
            node = fileSystem.getNodes().get(0);

        String[] way = path.split("/");

        if (node != null) {
            for (String piece : way) {
                if (piece.equals(".."))
                    if (!node.getDataName().equals("/"))
                        node = node.getDataFather();
                    else return null;
                else if (!piece.equals("") && !piece.equals(".") && !piece.equals(" ")) {
                    ok = false;
                    for (Node aux : node.getContent())
                        if (aux.getDataName().equals(piece) && aux instanceof Folder) {
                            node = aux;
                            ok = true;
                        }

                    if (!ok) {
                        return null;
                    }
                }
            }
        }
        return node;
    }
}