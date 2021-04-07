import java.util.*;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.Semaphore;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Class that implements the channel used by headquarters and space explorers to communicate.
 */
public class CommunicationChannel {

	//One queue = one way of the communication channel
	private BlockingQueue<Message> ExplorerToHQ;
	private BlockingQueue<Message> HQToExplorer;

	private final ReentrantLock mutexWrite;
	private final ReentrantLock mutexRead;

	/**
	 * Creates a {@code CommunicationChannel} object.
	 */
	public CommunicationChannel() {

		this.HQToExplorer = new LinkedBlockingQueue<>();
		this.ExplorerToHQ = new LinkedBlockingQueue<>();
		this.mutexWrite = new ReentrantLock();
		this.mutexRead = new ReentrantLock();
	}

	/**
	 * Puts a message on the space explorer channel (i.e., where space explorers write to and
	 * headquarters read from).
	 *
	 * @param message message to be put on the channel
	 */
	public void putMessageSpaceExplorerChannel(Message message) {

		try {
			this.ExplorerToHQ.put(message);
		} catch (Exception e) { return; }
	}

	/**
	 * Gets a message from the space explorer channel (i.e., where space explorers write to and
	 * headquarters read from).
	 *
	 * @return message from the space explorer channel
	 */
	public Message getMessageSpaceExplorerChannel() {

		try {
			return this.ExplorerToHQ.take();
		} catch (Exception e) { return null; }
	}

	/**
	 * Puts a message on the headquarters channel (i.e., where headquarters write to and
	 * space explorers read from).
	 *
	 * @param message message to be put on the channel
	 */
	public void putMessageHeadQuarterChannel(Message message) {

		//For every message, put a lock to only allow the current thread to send 2 messages as we don't actually
		//care about END or EXIT as the HeadQuarter will automatically do System.exit when needed.
		mutexWrite.lock();

		if (!message.getData().equals(HeadQuarter.END) && !message.getData().equals(HeadQuarter.EXIT)) {

			try {
				HQToExplorer.put(message);
			} catch (Exception e) { return; }

			//After 2 messages were sent, we can unlock
			if (mutexWrite.getHoldCount() == 2) {
				mutexWrite.unlock();
				mutexWrite.unlock();
			}
		}

		//At this stage, there should be 3 locks in place, 2 already unlocked after the 2-pair messages were sent
		else {
			mutexWrite.unlock();
		}
	}

	/**
	 * Gets a message from the headquarters channel (i.e., where headquarters write to and
	 * space explorer read from).
	 *
	 * @return message from the header quarter channel
	 */
	public Message getMessageHeadQuarterChannel() {

		//Same idea as write, place a lock for any taken message. After taking 2, double unlock to let other space-explorer go next
		Message message = null;
		mutexRead.lock();

		try{
			message = HQToExplorer.take();
		}catch(Exception e){ return null; }

		if(mutexRead.getHoldCount() == 2){
			mutexRead.unlock();
			mutexRead.unlock();
		}

		return message;
	}
}
