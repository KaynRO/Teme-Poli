public class Premium extends Basic {
    public int premiumLeft;

    public Premium(String subscriptionName, int basicLeft, int premiumLeft) {
        super(subscriptionName, basicLeft);
        this.premiumLeft = premiumLeft;
    }

    //If no more premium subscriptions left we go to "Basic"
    @Override
    public String getSubscription() {
        if (this.premiumLeft < 1)
            return super.getSubscription();
        else {
            this.premiumLeft--;
            return "Premium";
        }
    }
}
