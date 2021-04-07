import java.util.ArrayList;
import java.util.Collections;

//Where all the magic happens. This is where all datas are store, updated.
class FileSystem {
    private ArrayList<Node> nodes;
    private Node currentDirectory;

    FileSystem() {
        Folder root = new Folder("/", null, new ArrayList<>());
        nodes = new ArrayList<>();
        nodes.add(root);
        currentDirectory = root;
    }

    Node getCurrentDirectory() {
        return currentDirectory;
    }

    ArrayList<Node> getNodes() {
        return nodes;
    }

    //We know the node from where to start so simply go depth and print what we find
    String ls(Node node, int recursive, StringBuilder result) {
        result.append(pwd(node));
        result.append(":\n");

        if (node.getContent() != null) {

            Collections.sort(node.getContent());
            for (Node aux : node.getContent()) {
                result.append(pwd(node));
                result.append((pwd(node).equals("/") ? "" : "/"));
                result.append(aux.getDataName());
                if (aux != node.getContent().get(node.getContent().size() - 1))
                    result.append(" ");
            }
            result.append("\n\n");
        }

        if (node.getContent() != null) {
            for (Node aux : node.getContent())
                if (recursive == 1 && aux instanceof Folder)
                    result = new StringBuilder(ls(aux, recursive, result));
        }

        return result.toString();
    }

    //Create a new folder with the desired name and add it to the node
    void mkdir(Node node, String name) {
        Node newNode = new Folder(name, node, new ArrayList<>());
        node.add(newNode);
        nodes.add(newNode);
    }

    //Create a new file with the desired name and add it to the node
    void touch(Node node, String name) {
        Node newNode = new File(name, node);
        node.add(newNode);
        nodes.add(newNode);
    }

    //Change filesystem's current working directory
    void cd(Node node) {
        currentDirectory = node;
    }

    //Starting from the given node, we go "up"(node -> father) until we get to the root directory
    String pwd(Node start) {
        Node node = start;
        StringBuilder result = new StringBuilder();
        ArrayList<String> rootPath = new ArrayList<>();

        while (!node.getDataName().equals("/")) {
            rootPath.add(node.getDataName());
            node = node.getDataFather();
        }

        Collections.reverse(rootPath);

        for (String aux : rootPath) {
            result.append("/");
            result.append(aux);
        }

        if (rootPath.size() == 0)
            result.append("/");

        return result.toString();
    }

    //Create a fresh new node with the same fields as the source and update it's content
    void cp(Node source, Node destination) {
        Node node;

        if (source instanceof File)
            node = new File(source.getDataName(), destination);
        else node = new Folder(source.getDataName(), destination, new ArrayList<>(source.getContent()));

        node.update();
        destination.add(node);
    }

    //Just change source's father name, delete it from it's subtree and add it to the new's father one
    void mv(Node source, Node destination) {
        source.getDataFather().remove(source);
        source.setDataFather(destination);
        destination.add(source);
    }

    //Remove from father's subtree
    void rm(Node source) {
        if (source != null) {
            source.getDataFather().remove(source);
            nodes.remove(source);
        }
    }
}