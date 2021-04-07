import java.util.ArrayList;

public class Memory implements Cache {
    public ArrayList<Subscription> arrayList;

    //Simple memory class
    public Memory(int dimension) {
        arrayList = new ArrayList<Subscription>(dimension);
    }

    //Remove object with matching name
    public void remove(String subscriptionName) {
        Subscription object = arrayList.get(0);
        for (Subscription x : arrayList) {
            if (x.subscriptionName.equals(subscriptionName))
                object = x;
        }
        arrayList.remove(object);
    }

    //Get index of matching name
    public int getIndex(String subscriptionName) {
        for (int i = 0; i < arrayList.size(); i++)
            if (arrayList.get(i).subscriptionName.equals(subscriptionName))
                return i;
        return -1;
    }

    //Add new element
    public void add(Subscription object) {
            arrayList.add(object);
    }
}
