package ro.pub.cs.systems.eim.colocviu1_3;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import java.util.Date;
import java.util.Random;
import android.os.Process;


public class ProcessingThread extends Thread {
    private final Context context;
    private boolean isRunning = true;
    private final Random random = new Random();
    private final Integer sum;
    public final Integer difference;

    public ProcessingThread(Context context, Integer sum, Integer difference) {
        this.context = context;
        this.sum = sum;
        this.difference = difference;
    }


    @Override
    public void run() {
        Log.d(Constants.PROCESSING_THREAD_TAG, "Thread has started! PID: " + Process.myPid() + " TID: " + Process.myTid());
        while (isRunning) {
            sendMessage(sum);
            sleep();
            sendMessage(difference);
            stopThread();
        }
        Log.d(Constants.PROCESSING_THREAD_TAG, "Thread has stopped!");
    }

    private void sendMessage(Integer message) {
        Intent intent = new Intent();
        intent.setAction(Constants.actionTypes[random.nextInt(Constants.actionTypes.length)]);
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