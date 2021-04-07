class CharacterTokenizer extends TokenizerDecorator {

    private int index = 0;
    String word = (String)tokenizer.getNext() ;

    CharacterTokenizer(Tokenizer tokenizer) {
        super(tokenizer);
    }

    public Character getNext() {
        try {
            return word.charAt(index++);
        } catch (Exception e) {
            word = (String)tokenizer.getNext() ;
            index = 0 ;
            return word.charAt(index++) ;
        }
    }
}
