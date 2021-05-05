package ro.pub.cs.systems.eim.colocviu1_2;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;

import java.util.Objects;
import java.util.regex.Pattern;

public class Colocviu1_2SecondaryActivity extends AppCompatActivity {

    public String[] terms;
    public Integer all_terms_sum = 0;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Intent intent = getIntent();
        if (intent != null && intent.getExtras().containsKey(Constants.ALL_TERMS))
            terms = Objects.requireNonNull(intent.getStringExtra(Constants.ALL_TERMS)).split(Pattern.quote(Constants.PLUS));


        for (String term : terms) all_terms_sum += Integer.parseInt(term);
        setResult(all_terms_sum);
        finish();
    }
}