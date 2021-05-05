package ro.pub.cs.systems.eim.colocviu1_2;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import java.util.Objects;

public class Colocviu1_2MainActivity extends AppCompatActivity {

    public EditText next_term;
    public TextView all_terms;
    public Button button_add;
    public Button button_compute;
    public String last_all_terms = Constants.EMPTY;
    public String serviceStatus = Constants.SERVICE_STOPPED;
    public Integer all_terms_sum;

    private final MessageBroadcastReceiver messageBroadcastReceiver = new MessageBroadcastReceiver();
    private final ButtonClickListener buttonClickListener = new ButtonClickListener();
    private final IntentFilter intentFilter = new IntentFilter();



    private class ButtonClickListener implements View.OnClickListener{

        @SuppressLint("NonConstantResourceId")
        @Override
        public void onClick(View view){
            switch(view.getId()){
                case R.id.button_add:
                    try {
                        if (all_terms.getText().toString().length() != 0)
                            all_terms.append(Constants.PLUS);
                        all_terms.append(String.valueOf(Integer.parseInt(next_term.getText().toString())));
                    }
                    catch (NumberFormatException e){
                    }

                    next_term.setText(Constants.EMPTY);
                    break;
                case R.id.button_compute:
                    if (last_all_terms.equals(all_terms.getText().toString()))
                        Toast.makeText(getApplicationContext(), "Saved sum is: " + all_terms_sum, Toast.LENGTH_LONG).show();
                    else {
                        Intent intent = new Intent(getApplicationContext(), Colocviu1_2SecondaryActivity.class);
                        intent.putExtra(Constants.ALL_TERMS, all_terms.getText().toString());
                        startActivityForResult(intent, Constants.SECONDARY_ACTIVITY_REQUEST_CODE);
                        last_all_terms = all_terms.getText().toString();
                    }
                    break;
            }
        }
    }


    private class MessageBroadcastReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            Toast.makeText(getApplicationContext(), Constants.BROADCAST_RECEIVER_TAG + Objects.requireNonNull(intent.getStringExtra(Constants.BROADCAST_RECEIVER_EXTRA)), Toast.LENGTH_LONG).show();
        }
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_practical_test01_2_main);

        next_term = (EditText)findViewById(R.id.next_term);
        all_terms = (TextView)findViewById(R.id.all_terms);
        button_add = (Button)findViewById(R.id.button_add);
        button_compute = (Button)findViewById(R.id.button_compute);

        button_add.setOnClickListener(buttonClickListener);
        button_compute.setOnClickListener(buttonClickListener);

        if (savedInstanceState != null && savedInstanceState.containsKey(Constants.ALL_TERMS_SUM))
            all_terms_sum = savedInstanceState.getInt(Constants.ALL_TERMS_SUM, 0);
        else
            all_terms_sum = 0;

        for (int index = 0; index < Constants.actionTypes.length; index++) {
            intentFilter.addAction(Constants.actionTypes[index]);
        }
    }


    @Override
    public void onRestoreInstanceState(Bundle savedInstanceState){
        if (savedInstanceState != null && savedInstanceState.containsKey(Constants.ALL_TERMS_SUM))
            all_terms_sum = savedInstanceState.getInt(Constants.ALL_TERMS_SUM, 0);
        else
            all_terms_sum = 0;
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        if (requestCode == Constants.SECONDARY_ACTIVITY_REQUEST_CODE) {
            Toast.makeText(this, "The sum is: " + resultCode, Toast.LENGTH_LONG).show();
            all_terms_sum = resultCode;
        }

        if (serviceStatus.equals(Constants.SERVICE_STOPPED) && all_terms_sum > 10){
            Intent intentS = new Intent(getApplicationContext(), Colocviu1_2Service.class);
            intentS.putExtra(Constants.EXTRA_MESSAGE, all_terms_sum);
            getApplicationContext().startService(intentS);
            serviceStatus = Constants.SERVICE_STARTED;
        }

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
    protected void onDestroy(){
        Intent intent = new Intent(this, Colocviu1_2Service.class);
        stopService(intent);
        super.onDestroy();
    }
}