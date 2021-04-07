public class Basic extends Free {
    public int basicLeft;

    public Basic(String subscriptionName, int basicLeft) {
        super(subscriptionName);
        this.basicLeft = basicLeft;
    }

    //If we have no more basic subscriptions left then we got to our parent, "Free"
    @Override
    public String getSubscription() {
        if (this.basicLeft == 0)
            return super.getSubscription();
        else {
            this.basicLeft--;
            return "Basic";
        }
    }

}