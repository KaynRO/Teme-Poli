package ro.pub.cs.systems.eim.colocviu1_3;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;

public class Colocviu1_3Service extends Service {
    private ProcessingThread processingThread = null;
    public Colocviu1_3Service() {
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Integer integer1 = intent.getIntExtra(Constants.INTEGER1, 0);
        Integer integer2 = intent.getIntExtra(Constants.INTEGER2, 0);
        processingThread = new ProcessingThread(this, (integer1 + integer2), (integer1 - integer2));
        processingThread.start();
        return Service.START_REDELIVER_INTENT;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy(){
        processingThread.stopThread();
    }
}