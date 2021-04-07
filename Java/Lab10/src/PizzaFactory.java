enum PizzaType {
    BONITO,
    SPECIALITY,
    TUNA,
    FAMILY
}

class PizzaFactory {
    private static Pizza instance = null;

    public static Pizza getInstance(PizzaType type, int size, double price) {
        if (instance == null) {
            switch (type) {
                case BONITO:
                    return new Bonito(size, price);
                case SPECIALITY:
                    return new Speciality(size, price);
                case TUNA:
                    return new Tuna(size, price);
                case FAMILY:
                    return new Family(size, price);
            }
        }
        return instance;
    }
}
