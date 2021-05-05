package ro.pub.cs.systems.eim.colocviu1_2;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;

public class Colocviu1_2Service extends Service {
    private ProcessingThread processingThread = null;
    public Colocviu1_2Service() {
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Integer sum = intent.getIntExtra(Constants.EXTRA_MESSAGE, 0);
        processingThread = new ProcessingThread(this, sum);
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