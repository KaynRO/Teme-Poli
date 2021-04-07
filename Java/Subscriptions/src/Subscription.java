public abstract class Subscription {
    //Template to be extended
    public String subscriptionName = "";
    public int used = 0 ;

    public Subscription() {
    }

    public Subscription(String subscriptionName) {
        this.subscriptionName = subscriptionName;
    }

    public String getSubscription() {
        return "True";
    }
}
