abstract class TokenizerDecorator implements Tokenizer {

    public Tokenizer tokenizer;

    TokenizerDecorator(Tokenizer tokenizer) {
        this.tokenizer = tokenizer;
    }

    public Object getNext() {
        return tokenizer.getNext();
    }
}
