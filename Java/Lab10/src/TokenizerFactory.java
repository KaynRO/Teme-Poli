import java.util.ArrayList;

enum Token {
    CHARACTER,
    STOP,
    LOWERCASE
}

class TokenizerFactory {

    private static Tokenizer tokenizer ;

    TokenizerFactory(String text){
        tokenizer = new WordTokenizer(text) ;
    }

    public static TokenizerDecorator create(Token tokenType) {

        ArrayList<String> delete = new ArrayList<>();
        delete.add("MERE");
        delete.add("rosii");
        delete.add("Ana") ;

        switch (tokenType) {
            case STOP:
                return new StopWordsTokenizer(TokenizerFactory.tokenizer, delete);
            case CHARACTER:
                return new CharacterTokenizer(TokenizerFactory.tokenizer);
            case LOWERCASE:
                return new LowerCaseTokenizer(TokenizerFactory.tokenizer);
        }

        return null ;
    }

    public void nextWord(){
        TokenizerFactory.tokenizer.getNext() ;
    }

    public static void main(String[] args) {

        TokenizerFactory tokenizerFactory = new TokenizerFactory("Ana are foarte multe MERE verzi SI ROSII") ;

        TokenizerDecorator character = TokenizerFactory.create(Token.CHARACTER) ;
        TokenizerDecorator lowercase = TokenizerFactory.create(Token.LOWERCASE) ;
        TokenizerDecorator stop = TokenizerFactory.create(Token.STOP) ;

        System.out.println(character.getNext());
        System.out.println(character.getNext());
        System.out.println(character.getNext());
        System.out.println(character.getNext());

        //System.out.println(stop.getNext());
        //System.out.println(stop.getNext());
        //System.out.println(stop.getNext());
        //System.out.println(stop.getNext());

        //System.out.println(lowercase.getNext());
        //System.out.println(lowercase.getNext());
        //System.out.println(lowercase.getNext());
        //System.out.println(lowercase.getNext());

    }
}
