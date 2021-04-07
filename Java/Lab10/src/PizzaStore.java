import java.util.ArrayList;

class PizzaStore {

    public static void main(String[] args) {
        ArrayList<Pizza> pizzas = new ArrayList<>();

        pizzas.add(PizzaFactory.getInstance(PizzaType.BONITO, 3, 15));
        pizzas.add(PizzaFactory.getInstance(PizzaType.FAMILY, 5, 25));
        pizzas.add(PizzaFactory.getInstance(PizzaType.TUNA, 7, 35));
        pizzas.add(PizzaFactory.getInstance(PizzaType.SPECIALITY, 9, 45));

        for (Pizza pizza : pizzas)
            System.out.println(pizza);
    }
}
