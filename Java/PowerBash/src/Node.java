import java.util.ArrayList;

//Define a node of our filesystem. File/Folder inherits this
abstract class Node implements Comparable<Node> {
    private Node dataFather;
    private String dataName;
    private ArrayList<Node> content;


    Node(String dataName, Node dataFather, ArrayList<Node> content) {
        this.dataName = dataName;
        this.dataFather = dataFather;
        this.content = content;
    }

    String getDataName() {
        return dataName;
    }

    Node getDataFather() {
        return dataFather;
    }

    ArrayList<Node> getContent() {
        return content;
    }

    void remove(Node node) {
        content.remove(node);
    }

    void add(Node node) {
        content.add(node);
    }

    void setDataFather(Node node) {
        this.dataFather = node;
    }

    boolean contains(String name) {
        for (Node aux : content)
            if (aux.getDataName().equals(name))
                return true;
        return false;
    }

    //When we want to copy a file/folder to somewhere, we have to make sure, all it's content gets update(it's father points to the new one
    void update() {
        Node node;
        if (content != null)
            for (int i = 0; i < content.size(); i++) {
                if (content.get(i) instanceof File)
                    node = new File(content.get(i).getDataName(), this);
                else
                    node = new Folder(content.get(i).getDataName(), this, new ArrayList<>(content.get(i).getContent()));
                content.set(i, node);
                node.update();
            }
    }

    public int compareTo(Node node) {
        return dataName.compareTo(node.dataName);
    }
}
