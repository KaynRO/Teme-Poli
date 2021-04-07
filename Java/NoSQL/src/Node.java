import java.io.FileWriter;
import java.util.ArrayList;

// A node will consists of a list of entities and also will have a maximum capacity and a unique order number.
// We define some basic methods that will search, remove, print or update a specific entity in the list.Also
// we define the class as comparable so can we can sort it based on the timestamp and order.
public class Node implements Comparable<Node> {

    private int maxCapacity;
    private int order;
    private ArrayList<Entity> entityList = new ArrayList<>();

    Node(int maxCapacity, int order) {
        this.maxCapacity = maxCapacity;
        this.order = order;
    }

    void add(Entity entity) {
        entityList.add(entity);
    }

    int getSize() {
        return entityList.size();
    }

    private int getOrder() {
        return order;
    }

    boolean isFull() {
        return entityList.size() != maxCapacity;
    }

    int getIndex(String entityName, String primaryKey) {
        for (int i = 0; i < entityList.size(); i++)
            if (entityList.get(i).getEntityName().equals(entityName) && entityList.get(i).getPrimaryKey().equals(primaryKey)) {
                return i;
            }
        return -1;
    }

    boolean remove(String entityName, String primaryKey) {
        int index = getIndex(entityName, primaryKey);
        if (index != -1) {
            entityList.remove(index);
            return true;
        } else
            return false;
    }

    void print(String entityName, String primaryKey, FileWriter writer) throws Exception {
        int index = getIndex(entityName, primaryKey);
        entityList.get(index).print(writer);
    }

    void updateEntity(int index, ArrayList<String> attributeNames, ArrayList<String> attributeValues) {
        entityList.get(index).setAttributeValue(attributeNames, attributeValues);
        Entity aux = entityList.get(index);
        entityList.remove(index);
        entityList.add(aux);
    }

    void removeByTimestamp(long timestamp) {
        ArrayList<Entity> toRemove = new ArrayList<>();
        for (Entity entity : entityList)
            if (entity.getTimestamp() < timestamp)
                toRemove.add(entity);
        for (Entity entity : toRemove)
            entityList.remove(entity);
    }

    void printAll(FileWriter writer) throws Exception {
        for (int i = entityList.size() - 1; i >= 0; i--) {
            entityList.get(i).print(writer);
        }
    }

    public int compareTo(Node aux) {
        if (entityList.size() > aux.getSize())
            return 1;
        if (entityList.size() == aux.getSize() && order > aux.getOrder())
            return 1;
        return 0;

    }
}
