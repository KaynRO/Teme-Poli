class LowerCaseTokenizer extends TokenizerDecorator {

    LowerCaseTokenizer(Tokenizer tokenizer) {
        super(tokenizer);
    }

    public String getNext() {
        String word = (String)tokenizer.getNext() ;
        return word.toLowerCase() ;
    }
}
