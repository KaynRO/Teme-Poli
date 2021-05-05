package ro.pub.cs.systems.eim.colocviu1_3;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

public class Colocviu1_3SecondaryActivity extends AppCompatActivity {

    public TextView equation;
    public Button buttonCorrect;
    public Button buttonIncorrect;

    private final ButtonClickListener buttonClickListener = new ButtonClickListener();

    private class ButtonClickListener implements View.OnClickListener{
        @SuppressLint({"SetTextI18n", "NonConstantResourceId"})
        @Override
        public void onClick(View view){
            switch(view.getId()){
                case R.id.button_correct:
                    setResult(Constants.CORRECT);
                    break;
                case R.id.button_incorrect:
                    setResult(Constants.INCORRECT);
                    break;
            }
            finish();
        }
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_colocviu1_3_secondary);

        equation = (TextView)findViewById(R.id.equation2);
        buttonCorrect = (Button)findViewById(R.id.button_correct);
        buttonIncorrect = (Button)findViewById(R.id.button_incorrect);

        buttonCorrect.setOnClickListener(buttonClickListener);
        buttonIncorrect.setOnClickListener(buttonClickListener);

        Intent intent = getIntent();
        if (intent != null && intent.getExtras().containsKey(Constants.EQUATION))
            equation.setText(intent.getStringExtra(Constants.EQUATION));

    }
}