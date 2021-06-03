package ro.pub.cs.systems.eim.practicaltest02.model;

public class Pokedex {

    private String pokemonType;
    private String pokemonAbilities;
    private String pokemonImage;

    public Pokedex() {
        this.pokemonType = null;
        this.pokemonAbilities = null;
        this.pokemonImage = null;
    }

    public Pokedex(String pokemonType, String pokemonAbilities, String pokemonImage) {
        this.pokemonType = pokemonType;
        this.pokemonAbilities = pokemonAbilities;
        this.pokemonImage = pokemonImage;
    }

    public String getPokemonType() {
        return pokemonType;
    }

    public void setPokemonType(String pokemonType) {
        this.pokemonType = pokemonType;
    }

    public String getPokemonAbilities() {
        return pokemonAbilities;
    }

    public void setPokemonAbilities(String pokemonAbilities) {
        this.pokemonAbilities = pokemonAbilities;
    }

    public String getPokemonImage() {
        return pokemonImage;
    }

    public void setPokemonImage(String pokemonImage) {
        this.pokemonImage = pokemonImage;
    }

    @Override
    public String toString() {
        return "Pokedex{" +
                "pokemonType='" + pokemonType + '\'' +
                ", pokemonAbilities='" + pokemonAbilities + '\'' +
                ", pokemonImage='" + pokemonImage + '\'' +
                '}';
    }

}