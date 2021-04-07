import java.util.ArrayList;

public class FIFOCache implements Cache {
    public int nrObjMax;
    public ArrayList<Subscription> arrayList;

    public FIFOCache(int nrObjMax) {
        this.nrObjMax = nrObjMax;
        arrayList = new ArrayList<Subscription>();
    }

    //First in, position 0 is the first to remove when a new element comes
    public void add(Subscription element) {
        if (this.nrObjMax == this.arrayList.size()) {
            this.arrayList.remove(0);
        }
        this.arrayList.add(element);
    }

    public void remove(int index) {
        this.arrayList.remove(index);
    }

    public int getIndex(String subscriptionName) {
        for (int i = 0; i < this.arrayList.size(); i++) {
            if (this.arrayList.get(i).subscriptionName.equals(subscriptionName))
                return i;
        }
        return -1;
    }
}
