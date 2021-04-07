class Family extends Pizza {

    Family(int size, double price) {
        super(size, price) ;
    }

    public String toString() {
        return "Family: " + super.toString();
    }
}
