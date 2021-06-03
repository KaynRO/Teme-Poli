package ro.pub.cs.systems.eim.practicaltest02.view;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import ro.pub.cs.systems.eim.practicaltest02.R;
import ro.pub.cs.systems.eim.practicaltest02.general.Constants;
import ro.pub.cs.systems.eim.practicaltest02.network.ClientThread;
import ro.pub.cs.systems.eim.practicaltest02.network.ServerThread;


public class MainActivity extends AppCompatActivity {

    private EditText serverPort = null;

    private EditText pokemonName = null;
    private EditText clientPort = null;
    private TextView pokemonType = null;
    private TextView pokemonAbilities = null;

    private ServerThread serverThread = null;

    private final ConnectButtonClickListener connectButtonClickListener = new ConnectButtonClickListener();
    private class ConnectButtonClickListener implements Button.OnClickListener {
        @Override
        public void onClick(View view) {
            String port = serverPort.getText().toString();
            if (port == null || port.isEmpty()) {
                Toast.makeText(getApplicationContext(), "[MAIN ACTIVITY] Server port should be filled!", Toast.LENGTH_SHORT).show();
                return;
            }
            serverThread = new ServerThread(Integer.parseInt(port));
            if (serverThread.getServerSocket() == null) {
                Log.e(Constants.TAG, "[MAIN ACTIVITY] Could not create server thread!");
                return;
            }
            serverThread.start();
        }

    }

    private final GetPokedexButtonListener getPokedexButtonListener = new GetPokedexButtonListener();
    private class GetPokedexButtonListener implements Button.OnClickListener {

        @Override
        public void onClick(View view) {
            String clientAddress = Constants.ADDRESS;
            String port = clientPort.getText().toString();
            if (clientAddress == null || clientAddress.isEmpty()
                    || port == null || port.isEmpty()) {
                Toast.makeText(getApplicationContext(), "[MAIN ACTIVITY] Client connection parameters should be filled!", Toast.LENGTH_SHORT).show();
                return;
            }
            if (serverThread == null || !serverThread.isAlive()) {
                Toast.makeText(getApplicationContext(), "[MAIN ACTIVITY] There is no server to connect to!", Toast.LENGTH_SHORT).show();
                return;
            }
            String pokeName = pokemonName.getText().toString();
            if (pokeName == null || pokeName.isEmpty()) {
                Toast.makeText(getApplicationContext(), "[MAIN ACTIVITY] Pokemon name should be filled", Toast.LENGTH_SHORT).show();
                return;
            }

            pokemonType.setText(Constants.EMPTY_STRING);
            pokemonAbilities.setText(Constants.EMPTY_STRING);

            ClientThread clientThread = new ClientThread(
                    clientAddress, Integer.parseInt(port), pokeName, pokemonType, pokemonAbilities
            );
            clientThread.start();
        }

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.i(Constants.TAG, "[MAIN ACTIVITY] onCreate() callback method has been invoked");
        setContentView(R.layout.activity_main);

        serverPort = (EditText)findViewById(R.id.port_server);
        Button connectButton = (Button) findViewById(R.id.connect_button);
        connectButton.setOnClickListener(connectButtonClickListener);

        pokemonName = (EditText)findViewById(R.id.pokemon_name_client);
        clientPort = (EditText)findViewById(R.id.port_client);
        Button getPokedex = (Button) findViewById(R.id.get_pokemon);
        getPokedex.setOnClickListener(getPokedexButtonListener);
        pokemonType = (TextView)findViewById(R.id.pokemon_type);
        pokemonAbilities = (TextView)findViewById(R.id.pokemon_abilities);
    }

    @Override
    protected void onDestroy() {
        Log.i(Constants.TAG, "[MAIN ACTIVITY] onDestroy() callback method has been invoked");
        if (serverThread != null) {
            serverThread.stopThread();
        }
        super.onDestroy();
    }

}