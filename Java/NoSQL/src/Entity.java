import java.io.FileWriter;
import java.util.*;

// We define an entity being identified by a name, primary key, a timestamp and a linked hash map.
// The hash map will keep track of all the current attributes of the entity paired name:value
public class Entity {

    private String entityName;
    private String primaryKey;
    private long timestamp;
    private LinkedHashMap<String, String> entityAttributes = new LinkedHashMap<>();

    Entity(String entityName, ArrayList<String> attributeNames, ArrayList<String> attributeValues) {
        this.entityName = entityName;
        timestamp = System.currentTimeMillis();
        primaryKey = attributeValues.get(0);
        for (int i = 0; i < attributeNames.size(); i++) {
            entityAttributes.put(attributeNames.get(i), attributeValues.get(i));
        }
    }

    String getEntityName() {
        return entityName;
    }

    String getPrimaryKey() {
        return primaryKey;
    }

    void setAttributeValue(ArrayList<String> attributeNames, ArrayList<String> attributeValue) {
        for (int i = 0; i < attributeNames.size(); i++) {
            entityAttributes.put(attributeNames.get(i), attributeValue.get(i));
            timestamp = System.currentTimeMillis();
        }
    }

    long getTimestamp() {
        return this.timestamp;
    }

    void print(FileWriter writer) throws Exception {
        writer.write(entityName + " ");
        Iterator mapIterator = entityAttributes.entrySet().iterator();
        while (mapIterator.hasNext()) {
            Map.Entry pair = (Map.Entry) mapIterator.next();
            writer.write(pair.getKey() + ":" + pair.getValue());
            if (mapIterator.hasNext())
                writer.write(" ");
        }
        writer.write("\n");
    }
}
