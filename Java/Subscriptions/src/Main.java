import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.Scanner;
import java.util.StringTokenizer;

public class Main {
    public static void main(String[] argv) {
        //Define variables to be used
        File inputFile = new File(argv[0]);
        File outputFile = new File(argv[1]);
        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter(outputFile));
            FIFOCache fifoCache = new FIFOCache(100);
            LRUCache lruCache = new LRUCache(100);
            Memory mainMemory = new Memory(10000);
            int idx;

            try {
                //Define scanner to read from file and get memory type and the maximum number of object allowed in the cache memory
                Scanner buffer = new Scanner(inputFile);
                String cacheType = buffer.nextLine();
                int nrObjMax = buffer.nextInt();
                int nrOperations = buffer.nextInt();

                //Create the cache memories
                if (cacheType.equals("LRU"))
                    lruCache = new LRUCache(nrObjMax);
                if (cacheType.equals("FIFO"))
                    fifoCache = new FIFOCache(nrObjMax);

                buffer.nextLine();

                for (int i = 0; i < nrOperations; i++) {
                    String line = buffer.nextLine();
                    StringTokenizer tokenizer = new StringTokenizer(line);

                    //Define token being " " and split each line by this token to extract datas
                    while (tokenizer.hasMoreElements()) {
                        String operationType = tokenizer.nextToken();

                        if (operationType.equals("ADD")) {
                            String objectName = tokenizer.nextToken();
                            int basicSubscription = Integer.parseInt(tokenizer.nextToken());

                            //If subscription already exists we replace it and remove from cache
                            if (mainMemory.getIndex(objectName) != -1) {
                                mainMemory.remove(objectName);

                                if (cacheType.equals("LRU") && lruCache.getIndex(objectName) != -1)
                                    lruCache.remove(lruCache.getIndex(objectName));
                                if (cacheType.equals("FIFO") && fifoCache.getIndex(objectName) != -1)
                                    fifoCache.remove(fifoCache.getIndex(objectName));
                            }

                            //Create the subscription objects and insert them in the main memory
                            if (tokenizer.hasMoreElements()) {
                                int premiumSubscriptions = Integer.parseInt(tokenizer.nextToken());
                                Premium subscriptionObject = new Premium(objectName, basicSubscription, premiumSubscriptions);
                                subscriptionObject.used++;
                                mainMemory.add(subscriptionObject);

                            } else {
                                Basic subscriptionObject = new Basic(objectName, basicSubscription);
                                subscriptionObject.used++;
                                mainMemory.add(subscriptionObject);

                            }
                        } else {
                            String objectName = tokenizer.nextToken();
                            int exists = 2;

                            //Object exists in main memory
                            idx = mainMemory.getIndex(objectName);
                            if (idx != -1)
                                exists--;

                            //Object exists in cache memory. If we have LRU cache then this object become newer, so we delete the old one and replace it
                            if (cacheType.equals("LRU") && lruCache.getIndex(objectName) != -1 && exists == 1) {
                                exists--;
                                lruCache.remove(lruCache.getIndex(objectName));
                                lruCache.add(mainMemory.arrayList.get(idx));
                            }
                            if (cacheType.equals("FIFO") && fifoCache.getIndex(objectName) != -1 && exists == 1)
                                exists--;

                            //Write object's type of subscription
                            if (exists == 0 || exists == 1) {
                                writer.append(exists + " " + mainMemory.arrayList.get(idx).getSubscription() + "\n");
                            }

                            if (exists == 2)
                                writer.append(exists + "\n");

                            //Else we insert it into cache memory
                            if (cacheType.equals("LRU") && lruCache.getIndex(objectName) == -1 && exists == 1)
                                lruCache.add(mainMemory.arrayList.get(idx));
                            if (cacheType.equals("FIFO") && fifoCache.getIndex(objectName) == -1 && exists == 1)
                                fifoCache.add(mainMemory.arrayList.get(idx));
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            writer.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}