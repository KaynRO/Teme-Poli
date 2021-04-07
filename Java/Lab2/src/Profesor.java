public class Profesor extends Persoana {
    public String materie ;

    public Profesor(){
    }

    public Profesor(String nume ,String materie){
        this.materie = materie ;
        this.nume = nume ;
    }

    @Override
    public String toString(){
        return "Profesor: " + super.toString() + ", " + this.materie;
    }

    public void preda(){
        System.out.println(super.toString() + " preda" ) ;
    }
}
