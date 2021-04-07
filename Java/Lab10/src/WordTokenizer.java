class WordTokenizer implements Tokenizer {

    public String[] words;
    private int index = 0;

    WordTokenizer(String text) {
        words = text.split(" ");
    }

     public String getNext() {
        return words[index++] ;
    }
}
