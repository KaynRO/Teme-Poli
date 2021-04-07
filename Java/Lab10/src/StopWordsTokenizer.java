import java.util.ArrayList;

class StopWordsTokenizer extends TokenizerDecorator {

    private ArrayList<String> delete;

    StopWordsTokenizer(Tokenizer tokenizer, ArrayList<String> delete) {
        super(tokenizer);
        this.delete = new ArrayList<String>(delete);
    }

    public String getNext() {
        String word = (String) tokenizer.getNext();
        if (!delete.contains(word))
            return word;
        return null;
    }
}
