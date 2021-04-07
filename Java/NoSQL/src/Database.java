import java.io.FileWriter;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;

// Here we define our database. This will consists of a table where we keep track of current entities( we add one when a
// "CREATE" command is read. Also we need a list of the database's nodes where we can look and extract/update nodes/entity's
// instances. To notice that in the actual instance of an entity we don't store attribute type(int,string or float) but we can get
// it from the table just by knowing the entity name
public class Database {
    private int maxCapacity;
    private ArrayList<Node> nodeList = new ArrayList<>();
    private ArrayList<EntityTemplate> table = new ArrayList<>();

    Database() {
    }

    Database(int noNodes, int maxCapacity) {
        this.maxCapacity = maxCapacity;
        for (int i = 0; i < noNodes; i++)
            nodeList.add(new Node(maxCapacity, i));
    }

    void createEntry(String entityName, int RF, ArrayList<String> attributeNames, ArrayList<String> attributeTypes) {
        table.add(new EntityTemplate(entityName, RF, attributeNames, attributeTypes));
    }

    private ArrayList<String> getEntryTypes(String entityName, ArrayList<String> attributeNames) {
        ArrayList<String> result = new ArrayList<>();
        for (EntityTemplate entityTemplate : table)
            if (entityTemplate.getEntityName().equals(entityName))
                for (String attributeName : attributeNames)
                    for (int k = 0; k < entityTemplate.getSize(); k++)
                        if (attributeName.equals(entityTemplate.getattributeNames().get(k)))
                            result.add(entityTemplate.getAttributeTypes().get(k));
        return result;
    }

    int getEntrySize(String entityName) {
        for (EntityTemplate entityTemplate : table) {
            if (entityTemplate.getEntityName().equals(entityName))
                return entityTemplate.getSize();
        }
        return -1;
    }

    private void check(int RF) {
        int start = 0;
        while (RF != 0 && start <= nodeList.size() - 1) {
            if (nodeList.get(start).isFull())
                RF--;
            start++;
        }
        while (RF != 0) {
            nodeList.add(new Node(maxCapacity, nodeList.size() - 1));
            RF--;
        }
    }

    private ArrayList<String> convertToFloat(ArrayList<String> attributeTypes, ArrayList<String> attributeValues) {
        for (int i = 0; i < attributeTypes.size(); i++)
            if (attributeTypes.get(i).equals("Float")) {
                attributeValues.set(i, new DecimalFormat("#.##").format(Float.parseFloat(attributeValues.get(i))));
            }
        return attributeValues;
    }

    void insert(String entityName, ArrayList<String> entityValues) {
        for (EntityTemplate entityTemplate : table)
            if (entityTemplate.getEntityName().equals(entityName)) {
                entityValues = new ArrayList<>(convertToFloat(entityTemplate.getAttributeTypes(), entityValues));
                Entity entity = new Entity(entityName, entityTemplate.getattributeNames(), entityValues);
                int start = 0;
                int RF = entityTemplate.getRF();
                check(RF);
                while (RF != 0 && start <= nodeList.size() - 1) {
                    if (nodeList.get(start).isFull()) {
                        nodeList.get(start).add(entity);
                        Collections.sort(nodeList);
                        RF--;
                    }
                    start++;
                }
            }
    }

    void update(String entityName, String primaryKey, ArrayList<String> attributeNames, ArrayList<String> attributeValues) {
        attributeValues = new ArrayList<>(convertToFloat(getEntryTypes(entityName, attributeNames), attributeValues));
        for (Node aux : nodeList) {
            int index = aux.getIndex(entityName, primaryKey);
            if (index != -1)
                aux.updateEntity(index, attributeNames, attributeValues);
        }
    }

    void delete(String entityName, String primaryKey, FileWriter writer) throws Exception {
        boolean result = false;
        for (Node node : nodeList)
            result |= node.remove(entityName, primaryKey);
        if (!result)
            writer.write("NO INSTANCE TO DELETE\n");
    }

    void snapshotDB(FileWriter writer) throws Exception {
        boolean hasInstance = false;
        for (int i = 0; i < nodeList.size(); i++) {
            if (nodeList.get(i).getSize() != 0) {
                writer.write("Nod" + (i + 1) + "\n");
                nodeList.get(i).printAll(writer);
                hasInstance = true;
            }
        }
        if (!hasInstance)
            writer.write("EMPTY DB\n");
    }

    void clean(long timestamp) {
        for (Node aux : nodeList) {
            aux.removeByTimestamp(timestamp);
        }
    }

    void print(String entityName, String primaryKey, FileWriter writer) throws Exception {
        int index = -1;
        for (int i = 0; i < nodeList.size(); i++)
            if (nodeList.get(i).getIndex(entityName, primaryKey) != -1) {
                writer.write("Nod" + (i + 1) + " ");
                index = i;
            }
        if (index == -1)
            writer.write("NO INSTANCE FOUND\n");
        else
            nodeList.get(index).print(entityName, primaryKey, writer);

    }
}