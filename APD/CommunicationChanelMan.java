import java.util.ArrayList;
import java.util.HashMap;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Class that implements the channel used by headquarters and space explorers to communicate.
 */
public class CommunicationChannel {

	/**
	 * Creates a {@code CommunicationChannel} object.
	 */

	BlockingQueue<Message> channelSP = new ArrayBlockingQueue<Message>(10000);
	BlockingQueue<Message> channelHQ = new ArrayBlockingQueue<Message>(10000);

	Message m1;
	Message m2;
	int count1 = 0;
	int count2 = 0;

	public CommunicationChannel() {
	}

;

	//sincronizare
	ReentrantLock HQ  = new ReentrantLock();
	ReentrantLock SP  = new ReentrantLock();
	//ReentrantLock HQChannelWrite  = new ReentrantLock();

	/**
	 * Puts a message on the space explorer channel (i.e., where space explorers write to and 
	 * headquarters read from).
	 * 
	 * @param message
	 *            message to be put on the channel
	 */
	public void putMessageSpaceExplorerChannel(Message message) {
		try{
			channelSP.put(message);
		} catch (InterruptedException e){
			return;
		}
	}

	/**
	 * Gets a message from the space explorer channel (i.e., where space explorers write to and
	 * headquarters read from).
	 * 
	 * @return message from the space explorer channel
	 */
	public Message getMessageSpaceExplorerChannel() {
		try{
			m1 = channelSP.take();
		} catch (InterruptedException e){
		}
		return m1;
	}

	/**
	 * Puts a message on the headquarters channel (i.e., where headquarters write to and 
	 * space explorers read from).
	 * 
	 * @param message
	 *            message to be put on the channel
	 */
	public void putMessageHeadQuarterChannel(Message message) {
		//long currentThread = Thread.currentThread().getId();

		//daca mesajul este end sau exit ignor
		if(!message.getData().equals(HeadQuarter.END) && !message.getData().equals(HeadQuarter.EXIT)) {

			HQ.lock();

			try {
				channelHQ.put(message);
			} catch (InterruptedException e){
				return;
			}

			count1 += 1;

			if(count1 == 2){
				HQ.unlock();
				HQ.unlock();
				count1 = 0;
			}
		}
	}

	/**
	 * Gets a message from the headquarters channel (i.e., where headquarters write to and
	 * space explorer read from).
	 * 
	 * @return message from the header quarter channel
	 */
	public Message getMessageHeadQuarterChannel() {

		SP.lock();
		try{
			m2 = channelHQ.take();
		} catch (InterruptedException e){

		}

		count2 += 1;

		if(count2 == 2){
			SP.unlock();
			SP.unlock();
			count2 = 0;
		}

		return m2;
	}
}
