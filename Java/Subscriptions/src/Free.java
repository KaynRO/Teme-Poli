public abstract class Free extends Subscription {

    public Free(String subscriptionName){
        super(subscriptionName) ;
    }

    //Unlimited subscriptions
    @Override
    public String getSubscription(){
        return "Free" ;
    }
}
