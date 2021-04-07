abstract class Pizza {
    private int size;
    private double price;

    Pizza(int size, double price) {
        this.size = size;
        this.price = price;
    }

    public String toString() {
        return "price " + price + " and size " + size;
    }
}
