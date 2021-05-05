package ro.pub.cs.systems.eim.Colocviu1_1;

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
import android.widget.TextView;

import java.util.Objects;

public class Colocviu1_1MainActivity extends AppCompatActivity {

    private TextView buttonText;
    private Integer clicks;
    public String serviceStatus = Constants.SERVICE_STOPPED;
    private final IntentFilter intentFilter = new IntentFilter();



    private final MessageBroadcastReceiver messageBroadcastReceiver = new MessageBroadcastReceiver();
    private static class MessageBroadcastReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            Log.d(Constants.BROADCAST_RECEIVER_TAG, Objects.requireNonNull(intent.getStringExtra(Constants.BROADCAST_RECEIVER_EXTRA)));
        }
    }

    public void buttonStartActivity(View view){
        Intent intent = new Intent(this, Colocviu1_1SecondActivity.class);
        buttonText.setText(Constants.EMPTY);
        clicks = 0;
        intent.putExtra(Constants.EXTRA_MESSAGE, buttonText.getText().toString());
        startActivity(intent);
    }


    private class ButtonClickListener implements View.OnClickListener{
        String text = buttonText.getText().toString();

        @SuppressLint("NonConstantResourceId")
        @Override
        public void onClick(View view){
            clicks++;
            switch(view.getId()){
                case R.id.button_north:
                    buttonText.append(Constants.North);
                    break;
                case R.id.button_south:
                    buttonText.append(Constants.South);
                    break;
                case R.id.button_east:
                    buttonText.append(Constants.East);
                    break;
                case R.id.button_west:
                    buttonText.append(Constants.West);
                    break;
            }
            buttonText.append(Constants.DELIMITER);
            if (text.split(Constants.DELIMITER).length == 4 && serviceStatus.equals(Constants.SERVICE_STOPPED)){
                Intent intent = new Intent(getApplicationContext(), Colocviu1_1Service.class);
                intent.putExtra(Constants.EXTRA_MESSAGE, text);
                getApplicationContext().startService(intent);
                serviceStatus = Constants.SERVICE_STARTED;
            }
        }
    }


    private final ButtonClickListener buttonClickListener = new ButtonClickListener();

    @Override
    protected void onSaveInstanceState(Bundle savedInstanceState) {
        savedInstanceState.putString(Constants.Clicks, clicks.toString());
        super.onSaveInstanceState(savedInstanceState);
    }


    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState){
        if(savedInstanceState != null)
            if(savedInstanceState.containsKey(Constants.Clicks))
                clicks = Integer.parseInt(savedInstanceState.getString(Constants.Clicks));
            else
                clicks = 0;
        else
            clicks = 0;
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (savedInstanceState != null)
            if (savedInstanceState.containsKey(Constants.Clicks))
                clicks = Integer.parseInt(savedInstanceState.getString(Constants.Clicks));
            else
                clicks = 0;
        else
            clicks = 0;


        setContentView(R.layout.activity_colocviu1_1_main);

        buttonText = (TextView) findViewById(R.id.button_text);
        Button buttonNorth = (Button) findViewById(R.id.button_north);
        Button buttonSouth = (Button) findViewById(R.id.button_south);
        Button buttonEast = (Button) findViewById(R.id.button_east);
        Button buttonWest = (Button) findViewById(R.id.button_west);

        buttonNorth.setOnClickListener(buttonClickListener);
        buttonSouth.setOnClickListener(buttonClickListener);
        buttonEast.setOnClickListener(buttonClickListener);
        buttonWest.setOnClickListener(buttonClickListener);

        for (int index = 0; index < Constants.actionTypes.length; index++) {
            intentFilter.addAction(Constants.actionTypes[index]);
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
        Intent intent = new Intent(this, Colocviu1_1Service.class);
        stopService(intent);
        super.onDestroy();
    }
}