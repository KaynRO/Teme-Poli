package ro.pub.cs.systems.eim.practicaltest01var05;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import java.util.Date;
import java.util.Random;
import android.os.Process;


public class ProcessingThread extends Thread {
    private final Context context;
    private boolean isRunning = true;

    private final String buttonList;

    public ProcessingThread(Context context, String buttonList) {
        this.context = context;
        this.buttonList = buttonList;
    }


    @Override
    public void run() {
        Log.d(Constants.PROCESSING_THREAD_TAG, "Thread has started! PID: " + Process.myPid() + " TID: " + Process.myTid());
        while (isRunning) {
            String[] list = buttonList.split(Constants.DELIMITER);
            for(String element: list){
                sendMessage(element);
                sleep();
            }
        }
        Log.d(Constants.PROCESSING_THREAD_TAG, "Thread has stopped!");
    }

    private void sendMessage(String message) {
        Intent intent = new Intent();
        intent.setAction(Constants.actionType);
        intent.putExtra(Constants.BROADCAST_RECEIVER_EXTRA,
                new Date(System.currentTimeMillis()) + " " + message);
        context.sendBroadcast(intent);
    }

    private void sleep() {
        try {
            Thread.sleep(5000);
        } catch (InterruptedException interruptedException) {
            interruptedException.printStackTrace();
        }
    }

    public void stopThread() {
        isRunning = false;
    }
}