public class Account {
    String name;
    double sum = 0;
    double interest = 0;

    public Account() {
    }

    ;

    public Account(double sum) {
        this.sum = sum;
    }

    void displaySum() {
        System.out.println("Current RON " + this.sum);
    }

    static class Transaction {

        Account upper;

        public Transaction(Account x) {
            upper = x;
        }

        void withdrawn(int value) {
            upper.sum -= value;
            System.out.println("Withdrawn " + value + " dollars\n");
            upper.interest += value / ((double) 100);
        }

        void deposit(int value) {
            upper.sum += value;
            System.out.println("Deposited " + value + " dollars\n");
        }
    }

    public static void main(String[] args) {
        Account b = new Account(3);
        Account.Transaction a = new Account.Transaction(b);
        a.deposit(20);
        a.withdrawn(5);
        a.withdrawn(8);
        System.out.println(b.sum + " " + b.interest);

        Account c = new Account(10) {

            void displaySum() {
                System.out.println("Current EURO " + this.sum / ((double) 4.5));
            }
        };
        c.displaySum();

    }
}
