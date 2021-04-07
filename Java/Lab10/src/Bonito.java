class Bonito extends Pizza {

    Bonito(int size, double price) {
        super(size, price) ;
    }

    public String toString() {
        return "Bonito: " + super.toString();
    }
}
