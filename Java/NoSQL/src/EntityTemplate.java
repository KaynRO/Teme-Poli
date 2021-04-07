import java.util.ArrayList;

//This is a basic template of an entity which contains the entity name, the replicant factor, all the attribute names and
//types of this entity. The entity class is actually an instance while this one is the actual entity sketch
public class EntityTemplate {
    private String entityName;
    private int RF;
    private ArrayList<String> attributeNames;
    private ArrayList<String> attributeTypes;

    EntityTemplate(String entityName, int RF, ArrayList<String> attributeNames, ArrayList<String> attributeTypes) {
        this.entityName = entityName;
        this.RF = RF;
        this.attributeNames = new ArrayList<>(attributeNames);
        this.attributeTypes = new ArrayList<>(attributeTypes);
    }

    ArrayList<String> getAttributeTypes() {
        return attributeTypes;
    }

    ArrayList<String> getattributeNames() {
        return attributeNames;
    }

    String getEntityName() {
        return entityName;
    }

    int getRF() {
        return RF;
    }

    int getSize() {
        return attributeNames.size();
    }
}
