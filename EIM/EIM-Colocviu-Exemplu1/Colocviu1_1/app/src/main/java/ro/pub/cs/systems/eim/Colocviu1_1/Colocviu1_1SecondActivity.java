package ro.pub.cs.systems.eim.Colocviu1_1;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

public class Colocviu1_1SecondActivity extends AppCompatActivity {

    private class ButtonClickListener implements View.OnClickListener{
        @SuppressLint("NonConstantResourceId")
        @Override
        public void onClick(View view){
            String buttonText = "";
            switch(view.getId()){
                case R.id.button_register:
                    buttonText = Constants.Register;
                    break;
                case R.id.button_cancel:
                    buttonText = Constants.Cancel;
                    break;
            }
            Toast.makeText(getApplicationContext(), buttonText, Toast.LENGTH_SHORT).show();
            finish();
        }
    }

    private final ButtonClickListener buttonClickListener = new ButtonClickListener();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_colocviu1_1_second);

        TextView mTextView = (TextView) findViewById(R.id.text_view);
        Intent intent = getIntent();
        if (intent != null && intent.getExtras().containsKey(Constants.EXTRA_MESSAGE)){
            mTextView.setText(intent.getStringExtra(Constants.EXTRA_MESSAGE));
        }

        Button buttonRegister = (Button)findViewById(R.id.button_register);
        Button buttonCancel = (Button)findViewById(R.id.button_cancel);
        buttonRegister.setOnClickListener(buttonClickListener);
        buttonCancel.setOnClickListener(buttonClickListener);


    }
}