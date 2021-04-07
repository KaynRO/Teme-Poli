class Tuna extends Pizza {

    Tuna(int size, double price) {
        super(size, price) ;
    }

    public String toString() {
        return "Tuna: " + super.toString();
    }
}
