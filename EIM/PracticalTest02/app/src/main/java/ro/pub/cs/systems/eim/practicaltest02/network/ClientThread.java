package ro.pub.cs.systems.eim.practicaltest02.network;

import android.util.Log;
import android.widget.TextView;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.Socket;

import ro.pub.cs.systems.eim.practicaltest02.general.Constants;
import ro.pub.cs.systems.eim.practicaltest02.general.Utilities;

public class ClientThread extends Thread {

    private final String address;
    public final String pokemonName;
    private final int port;
    private final TextView pokemonType;
    private final TextView pokemonAbilities;


    private Socket socket;

    public ClientThread(String address, int port, String pokemonName, TextView pokemonType, TextView pokemonAbilities) {
        this.address = address;
        this.port = port;
        this.pokemonType = pokemonType;
        this.pokemonAbilities = pokemonAbilities;
        this.pokemonName = pokemonName;
    }

    @Override
    public void run() {
        try {
            socket = new Socket(address, port);
            if (socket == null) {
                Log.e(Constants.TAG, "[CLIENT THREAD] Could not create socket!");
                return;
            }
            BufferedReader bufferedReader = Utilities.getReader(socket);
            PrintWriter printWriter = Utilities.getWriter(socket);
            if (bufferedReader == null || printWriter == null) {
                Log.e(Constants.TAG, "[CLIENT THREAD] Buffered Reader / Print Writer are null!");
                return;
            }
            printWriter.println(pokemonName);
            printWriter.flush();

            String pokedex = bufferedReader.readLine();
            if(pokedex != null)
                pokemonType.setText(pokedex);
            pokedex = bufferedReader.readLine();
            if(pokedex != null)
                pokemonAbilities.setText(pokedex);
            pokedex = bufferedReader.readLine();

        } catch (IOException ioException) {
            Log.e(Constants.TAG, "[CLIENT THREAD] An exception has occurred: " + ioException.getMessage());
            if (Constants.DEBUG) {
                ioException.printStackTrace();
            }
        } finally {
            if (socket != null) {
                try {
                    socket.close();
                } catch (IOException ioException) {
                    Log.e(Constants.TAG, "[CLIENT THREAD] An exception has occurred: " + ioException.getMessage());
                    if (Constants.DEBUG) {
                        ioException.printStackTrace();
                    }
                }
            }
        }
    }
}