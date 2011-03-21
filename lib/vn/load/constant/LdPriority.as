package vn.load.constant 
{
	/**
	 * Loader Priorities used when adding items into queue
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * 
	 */
	public class LdPriority {
		public static const ONLY_ME		: String = 'ONLY_ME'; /* stop all running items in all queues and start load me only */
		public static const IMMEDIATELY	: String = 'IMMEDIATELY'; /* stop the current loading item in the queue and load me, other queues still run */
		public static const QUEUE_FIRST	: String = 'QUEUE_FIRST'; /* push to the first position of the queue, so once this queue's loading item finish loading, i will be loaded */
		public static const QUEUE_LAST	: String = 'QUEUE_LAST'; /* push to the last position in the queue and wait until all previous item loaded */
		public static const PRELOAD		: String = 'PRELOAD'; /* lowest priority, only load when other queued items in all queues finished loading */
	}
}