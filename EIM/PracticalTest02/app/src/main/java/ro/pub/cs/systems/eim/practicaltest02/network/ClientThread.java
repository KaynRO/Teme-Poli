package ro.pub.cs.systems.eim.practicaltest02.network;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;
import android.widget.ImageView;
import android.widget.TextView;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.Socket;

import ro.pub.cs.systems.eim.practicaltest02.general.Constants;
import ro.pub.cs.systems.eim.practicaltest02.general.Utilities;

public class ClientThread extends Thread {

    private final String address;
    public final String pokemonName;
    private final int port;
    public TextView pokemonType;
    public TextView pokemonAbilities;
    public ImageView pokemonImage;


    private Socket socket;

    public ClientThread(String address, int port, String pokemonName, TextView pokemonType, TextView pokemonAbilities, ImageView pokemonImage) {
        this.address = address;
        this.port = port;
        this.pokemonType = pokemonType;
        this.pokemonAbilities = pokemonAbilities;
        this.pokemonName = pokemonName;
        this.pokemonImage = pokemonImage;
    }

    public static Bitmap loadBitmap(String url) {
        Bitmap mIcon11 = null;
        try {
            InputStream in = new java.net.URL(url).openStream();
            mIcon11 = BitmapFactory.decodeStream(in);
        } catch (Exception e) {
            Log.e("Error", e.getMessage());
            e.printStackTrace();
        }
        return mIcon11;
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

            String pokeType = bufferedReader.readLine();
            if(pokeType != null)
                pokemonType.post(new Runnable(){
                    @Override
                    public void run(){
                        pokemonType.setText(pokeType);
                    }
                });

            String pokeAbilities = bufferedReader.readLine();

            if(pokeAbilities != null)
                pokemonAbilities.post(new Runnable(){
                    @Override
                    public void run(){
                        pokemonAbilities.setText(pokeAbilities);
                    }
                });

            String pokeImage = bufferedReader.readLine();
            System.out.println(pokeImage);
            Bitmap bitmap = loadBitmap(pokeImage);
            if(pokeImage != null)
                pokemonImage.post(new Runnable(){
                    @Override
                    public void run(){
                        pokemonImage.setImageBitmap(bitmap);
                    }
                });

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