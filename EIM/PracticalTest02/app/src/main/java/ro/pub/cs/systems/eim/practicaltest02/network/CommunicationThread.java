package ro.pub.cs.systems.eim.practicaltest02.network;

import android.util.Log;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.Socket;


import cz.msebera.android.httpclient.HttpEntity;
import cz.msebera.android.httpclient.HttpResponse;
import cz.msebera.android.httpclient.client.HttpClient;
import cz.msebera.android.httpclient.client.ResponseHandler;
import cz.msebera.android.httpclient.client.methods.HttpGet;
import cz.msebera.android.httpclient.impl.client.BasicResponseHandler;
import cz.msebera.android.httpclient.impl.client.DefaultHttpClient;
import cz.msebera.android.httpclient.util.EntityUtils;
import ro.pub.cs.systems.eim.practicaltest02.general.Constants;
import ro.pub.cs.systems.eim.practicaltest02.general.Utilities;
import ro.pub.cs.systems.eim.practicaltest02.model.Pokedex;

public class CommunicationThread extends Thread {

    private ServerThread serverThread;
    private Socket socket;

    public CommunicationThread(ServerThread serverThread, Socket socket) {
        this.serverThread = serverThread;
        this.socket = socket;
    }

    @Override
    public void run() {
        if (socket == null) {
            Log.e(Constants.TAG, "[COMMUNICATION THREAD] Socket is null!");
            return;
        }
        try {
            BufferedReader bufferedReader = Utilities.getReader(socket);
            PrintWriter printWriter = Utilities.getWriter(socket);
            if (bufferedReader == null || printWriter == null) {
                Log.e(Constants.TAG, "[COMMUNICATION THREAD] Buffered Reader / Print Writer are null!");
                return;
            }
            Log.i(Constants.TAG, "[COMMUNICATION THREAD] Waiting for parameters from client (city / information type!");
            String pokemonName = bufferedReader.readLine();
            if (pokemonName == null || pokemonName.isEmpty()) {
                Log.e(Constants.TAG, "[COMMUNICATION THREAD] Error receiving pokemon name from client !");
                return;
            }

            Pokedex pokedex = null;
            if (0 == 1) {

            } else {
                Log.i(Constants.TAG, "[COMMUNICATION THREAD] Getting the information from the webservice...");
                HttpClient httpClient = new DefaultHttpClient();
                String pageSourceCode = "";

                HttpGet httpGet = new HttpGet(Constants.WEB_SERVICE_ADDRESS + pokemonName);
                HttpResponse httpGetResponse = httpClient.execute(httpGet);
                HttpEntity httpGetEntity = httpGetResponse.getEntity();

                if (httpGetEntity != null) {
                    pageSourceCode = EntityUtils.toString(httpGetEntity);
                }

                if (pageSourceCode == null) {
                    Log.e(Constants.TAG, "[COMMUNICATION THREAD] Error getting the information from the webservice!");
                    return;
                } else
                    Log.i(Constants.TAG, pageSourceCode );

                JSONObject content = new JSONObject(pageSourceCode);

                JSONArray abilitiesArray = content.getJSONArray(Constants.ABILITIES);
                String pokemonAbilities = "";

                for (int i = 1; i < abilitiesArray.length(); i++) {
                    JSONObject ability = abilitiesArray.getJSONObject(i);
                    JSONObject ability_name = new JSONObject(ability.getString(Constants.ABILITY));

                    pokemonAbilities += ability_name.getString(Constants.NAME);

                    if (i < abilitiesArray.length() - 1) {
                        pokemonAbilities += "\n";
                    }
                }


                JSONArray types_array = content.getJSONArray(Constants.TYPES);
                JSONObject pokemon_type = new JSONObject(types_array.getJSONObject(0).getString(Constants.TYPE));
                String pokemonType = pokemon_type.getString(Constants.NAME);

                String pokemonImage = content.getString(Constants.SPRITES);

                pokedex = new Pokedex(
                        pokemonType, pokemonAbilities, new JSONObject(pokemonImage).getString(Constants.DEFAULT)
                );
            }
            if (pokedex == null) {
                Log.e(Constants.TAG, "[COMMUNICATION THREAD] Weather Forecast Information is null!");
                return;
            }

            printWriter.println(pokedex.getPokemonType());
            printWriter.flush();
            printWriter.println(pokedex.getPokemonAbilities());
            printWriter.flush();
            printWriter.println(pokedex.getPokemonImage());
            printWriter.flush();
        } catch (IOException ioException) {
            Log.e(Constants.TAG, "[COMMUNICATION THREAD] An exception has occurred: " + ioException.getMessage());
            if (Constants.DEBUG) {
                ioException.printStackTrace();
            }
        } catch (JSONException jsonException) {
            Log.e(Constants.TAG, "[COMMUNICATION THREAD] An exception has occurred: " + jsonException.getMessage());
            if (Constants.DEBUG) {
                jsonException.printStackTrace();
            }
        } finally {
            if (socket != null) {
                try {
                    socket.close();
                } catch (IOException ioException) {
                    Log.e(Constants.TAG, "[COMMUNICATION THREAD] An exception has occurred: " + ioException.getMessage());
                    if (Constants.DEBUG) {
                        ioException.printStackTrace();
                    }
                }
            }
        }
    }

}