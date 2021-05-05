package ro.pub.cs.systems.eim.practicaltest01var05;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import java.util.Objects;

import static ro.pub.cs.systems.eim.practicaltest01var05.Constants.DELIMITER;

public class PracticalTest01Var05MainActivity extends AppCompatActivity {
    public TextView buttonList;
    public Button buttonTopLeft;
    public Button buttonTopRight;
    public Button buttonBottomLeft;
    public Button buttonBottomRight;
    public Button buttonCenter;
    public Button buttonNavigate;


    public Integer buttonClicks = 0;
    public String serviceStatus = Constants.SERVICE_STOPPED;

    private final MessageBroadcastReceiver messageBroadcastReceiver = new MessageBroadcastReceiver();
    private final ButtonClickListener buttonClickListener = new ButtonClickListener();
    private final IntentFilter intentFilter = new IntentFilter();


    private class ButtonClickListener implements View.OnClickListener{
        @SuppressLint("NonConstantResourceId")
        @Override
        public void onClick(View view){
            buttonClicks++;
            if (view.getId() != R.id.button_navigate && buttonList.getText().toString().length() != 0){
                if (serviceStatus.equals(Constants.SERVICE_STOPPED) && buttonList.getText().toString().split(Constants.DELIMITER).length + 1 > Constants.BUTTON_LIST_TRASHHOLD){
                    Intent intentS = new Intent(getApplicationContext(), PracticalTest01Var05Service.class);
                    intentS.putExtra(Constants.BUTTON_LIST, buttonList.getText().toString());
                    getApplicationContext().startService(intentS);
                    serviceStatus = Constants.SERVICE_STARTED;
                }
                buttonList.append(DELIMITER);
            }

            switch(view.getId()){
                case R.id.button_top_left:
                    buttonList.append(Constants.TOP_LEFT);
                    break;
                case R.id.button_top_right:
                    buttonList.append(Constants.TOP_RIGHT);
                    break;
                case R.id.button_center:
                    buttonList.append(Constants.CENTER);
                    break;
                case R.id.button_bottom_left:
                    buttonList.append(Constants.BOTTOM_LEFT);
                    break;
                case R.id.button_bottom_right:
                    buttonList.append(Constants.BOTTOM_RIGHT);
                    break;
                case R.id.button_navigate:
                    buttonClicks--;
                    Intent intent = new Intent(getApplicationContext(), PracticalTest01Var05SecondaryActivity.class);
                    intent.putExtra(Constants.BUTTON_LIST, buttonList.getText().toString());
                    startActivityForResult(intent, Constants.SECONDARY_ACTIVITY_REQUEST_CODE);
                    break;
            }
        }
    }


    private class MessageBroadcastReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            Log.d(Constants.BROADCAST_RECEIVER_TAG, Objects.requireNonNull(intent.getStringExtra(Constants.BROADCAST_RECEIVER_EXTRA)));
        }
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_practical_test01_var05_main);

        buttonList = (TextView)findViewById(R.id.button_list);
        buttonTopLeft = (Button)findViewById(R.id.button_top_left);
        buttonTopRight = (Button)findViewById(R.id.button_top_right);
        buttonBottomLeft = (Button)findViewById(R.id.button_bottom_left);
        buttonBottomRight = (Button)findViewById(R.id.button_bottom_right);
        buttonCenter = (Button)findViewById(R.id.button_center);
        buttonNavigate = (Button)findViewById(R.id.button_navigate);


        buttonTopLeft.setOnClickListener(buttonClickListener);
        buttonTopRight.setOnClickListener(buttonClickListener);
        buttonBottomLeft.setOnClickListener(buttonClickListener);
        buttonBottomRight.setOnClickListener(buttonClickListener);
        buttonCenter.setOnClickListener(buttonClickListener);
        buttonNavigate.setOnClickListener(buttonClickListener);


        if (savedInstanceState != null && savedInstanceState.containsKey(Constants.BUTTON_CLICKS)) {
            buttonClicks = savedInstanceState.getInt(Constants.BUTTON_CLICKS);
            System.out.println("YES");
            Toast.makeText(getApplicationContext(), Constants.BUTTON_CLICKS + buttonClicks, Toast.LENGTH_LONG).show();
        }
        else
            buttonClicks = 0;

            intentFilter.addAction(Constants.actionType);
    }


    @Override
    public void onSaveInstanceState(Bundle savedInstanceState) {
        savedInstanceState.putInt(Constants.BUTTON_CLICKS, buttonClicks);
        super.onSaveInstanceState(savedInstanceState);
    }


    @Override
    public void onRestoreInstanceState(Bundle savedInstanceState){
        if (savedInstanceState != null && savedInstanceState.containsKey(Constants.BUTTON_CLICKS)) {
            buttonClicks = savedInstanceState.getInt(Constants.BUTTON_CLICKS);
            Toast.makeText(getApplicationContext(), Constants.BUTTON_CLICKS + buttonClicks, Toast.LENGTH_LONG).show();
        }
        else
            buttonClicks = 0;
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        if (requestCode == Constants.SECONDARY_ACTIVITY_REQUEST_CODE)
            Toast.makeText(this, "Secondary activity result: " + resultCode, Toast.LENGTH_LONG).show();
        buttonList.setText(Constants.EMPTY);
        super.onActivityResult(requestCode, resultCode, intent);
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
    protected void onDestroy() {
        Intent intent = new Intent(this, PracticalTest01Var05Service.class);
        stopService(intent);
        super.onDestroy();
    }
}