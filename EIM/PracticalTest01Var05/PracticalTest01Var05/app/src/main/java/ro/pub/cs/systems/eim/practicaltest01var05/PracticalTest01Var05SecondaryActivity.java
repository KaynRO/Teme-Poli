package ro.pub.cs.systems.eim.practicaltest01var05;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import java.util.Objects;

public class PracticalTest01Var05SecondaryActivity extends AppCompatActivity {
    public TextView buttonList;
    public Button buttonVerify;
    public Button buttonCancel;

    private final ButtonClickListener buttonClickListener = new ButtonClickListener();


    private class ButtonClickListener implements View.OnClickListener{
        @SuppressLint("NonConstantResourceId")
        @Override
        public void onClick(View view){
            switch(view.getId()){
                case R.id.button_verify:
                    setResult(Constants.VERIFY);
                    break;
                case R.id.button_cancel:
                    setResult(Constants.CANCEL);
                    break;
            }
            finish();
        }
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_practical_test01_var05_secondary);

        buttonVerify = (Button)findViewById(R.id.button_verify);
        buttonCancel = (Button)findViewById(R.id.button_cancel);
        buttonList = (TextView)findViewById(R.id.button_list_second);

        buttonVerify.setOnClickListener(buttonClickListener);
        buttonCancel.setOnClickListener(buttonClickListener);

        Intent intent = getIntent();
        if (intent != null && intent.getExtras().containsKey(Constants.BUTTON_LIST))
            buttonList.setText(Objects.requireNonNull(intent.getStringExtra(Constants.BUTTON_LIST)));
    }
}