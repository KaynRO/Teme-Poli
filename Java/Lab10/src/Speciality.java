class Speciality extends Pizza {

    Speciality(int size, double price) {
        super(size, price) ;
    }

    public String toString() {
        return "Speciality: " + super.toString();
    }
}
