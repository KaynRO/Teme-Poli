package ro.pub.cs.systems.eim.colocviu1_3;

import androidx.appcompat.app.AppCompatActivity;
import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;
import java.util.Objects;

public class Colocviu1_3MainActivity extends AppCompatActivity {

    public EditText number1;
    public EditText number2;
    public TextView equation;
    public Button buttonPlus;
    public Button buttonMinus;
    public Button buttonNavigate;

    public String value1;
    public String value2;
    public Integer integer1;
    public Integer integer2;
    public String serviceStatus = Constants.SERVICE_STOPPED;

    private final ButtonClickListener buttonClickListener = new ButtonClickListener();
    private final MessageBroadcastReceiver messageBroadcastReceiver = new MessageBroadcastReceiver();
    private final IntentFilter intentFilter = new IntentFilter();


    private static class MessageBroadcastReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            Log.d(Constants.BROADCAST_RECEIVER_TAG, Objects.requireNonNull(intent.getStringExtra(Constants.BROADCAST_RECEIVER_EXTRA)));
        }
    }


    public void startCustomService(Integer integer1, Integer integer2){
        Intent intentS = new Intent(getApplicationContext(), Colocviu1_3Service.class);
        intentS.putExtra(Constants.INTEGER1, integer1);
        intentS.putExtra(Constants.INTEGER2, integer2);
        getApplicationContext().startService(intentS);
        serviceStatus = Constants.SERVICE_STARTED;
    }


    private class ButtonClickListener implements View.OnClickListener{
        @SuppressLint({"SetTextI18n", "NonConstantResourceId"})
        @Override
        public void onClick(View view){
            try{
                value1 = number1.getText().toString();
                value2 = number2.getText().toString();
                integer1 = Integer.parseInt(value1);
                integer2 = Integer.parseInt(value2);
            }
            catch (Exception e){
                Toast.makeText(getApplicationContext(), Constants.INTEGER_ERROR, Toast.LENGTH_LONG).show();
                return;
            }
            switch(view.getId()){
                case R.id.button_plus:
                    equation.setText(value1 + Constants.PLUS + value2 + Constants.EQUALS + (integer1 + integer2));
                    if (serviceStatus.equals(Constants.SERVICE_STOPPED))
                        startCustomService(integer1, integer2);
                    break;
                case R.id.button_minus:
                    equation.setText(value1 + Constants.MINUS + value2 + Constants.EQUALS + (integer1 - integer2));
                    if (serviceStatus.equals(Constants.SERVICE_STOPPED))
                        startCustomService(integer1, integer2);
                    break;
                case R.id.button_navigate:
                    Intent intent = new Intent(getApplicationContext(), Colocviu1_3SecondaryActivity.class);
                    intent.putExtra(Constants.EQUATION, equation.getText().toString());
                    startActivityForResult(intent, Constants.SECONDARY_ACTIVITY_REQUEST_CODE);
                    break;
            }
        }
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.colocviu1_3activity_main);

        number1 = (EditText)findViewById(R.id.number1);
        number2 = (EditText)findViewById(R.id.number2);
        equation = (TextView)findViewById(R.id.equation);
        buttonPlus = (Button)findViewById(R.id.button_plus);
        buttonMinus = (Button)findViewById(R.id.button_minus);
        buttonNavigate = (Button)findViewById(R.id.button_navigate);

        buttonPlus.setOnClickListener(buttonClickListener);
        buttonMinus.setOnClickListener(buttonClickListener);
        buttonNavigate.setOnClickListener(buttonClickListener);


        if (savedInstanceState != null){
            if (savedInstanceState.containsKey(Constants.NUMBER1))
                number1.setText(savedInstanceState.getInt(Constants.NUMBER1));
            if (savedInstanceState.containsKey(Constants.NUMBER2))
                number2.setText(savedInstanceState.getInt(Constants.NUMBER2));
            Toast.makeText(getApplicationContext(), Constants.NUMBER1 + number1 + '\n' + Constants.NUMBER2 + number2, Toast.LENGTH_LONG).show();

        }

        for (int index = 0; index < Constants.actionTypes.length; index++) {
            intentFilter.addAction(Constants.actionTypes[index]);
        }
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        if (requestCode == Constants.SECONDARY_ACTIVITY_REQUEST_CODE) {
            Toast.makeText(this, "Result code is: " + resultCode, Toast.LENGTH_LONG).show();
        }
        super.onActivityResult(requestCode, resultCode, intent);
    }


    @Override
    public void onRestoreInstanceState(Bundle savedInstanceState){
        if (savedInstanceState != null){
            if (savedInstanceState.containsKey(Constants.NUMBER1))
                number1.setText(savedInstanceState.getInt(Constants.NUMBER1));
            if (savedInstanceState.containsKey(Constants.NUMBER2))
                number2.setText(savedInstanceState.getInt(Constants.NUMBER2));
            Toast.makeText(getApplicationContext(), Constants.NUMBER1 + number1 + '\n' + Constants.NUMBER2 + number2, Toast.LENGTH_LONG).show();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        registerReceiver(messageBroadcastReceiver, intentFilter);
    }


    @Override
    protected void onPause() {
        unregisterReceiver(messageBroadcastReceiver);
        super.onPause();
    }


    @Override
    protected void onDestroy(){
        Intent intent = new Intent(this, Colocviu1_3Service.class);
        stopService(intent);
        super.onDestroy();
    }
}