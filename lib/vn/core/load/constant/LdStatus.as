package vn.core.load.constant 
{
	/**
	 * Loader and queue status used by LdQueue and LdBase
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * 
	 */
	public class LdStatus {
		public static const ITEM_QUEUED		: String = 'ITEM_QUEUED';
		public static const ITEM_LOADING	: String = 'ITEM_LOADING';
		public static const ITEM_LOADED		: String = 'ITEM_LOADED';
		public static const ITEM_ERROR		: String = 'ITEM_ERROR';
		
		public static const QUEUE_IDLE		: String = 'QUEUE_IDLE';
		public static const QUEUE_PAUSED	: String = 'QUEUE_PAUSED';
		public static const QUEUE_RUNNING	: String = 'QUEUE_RUNNING';
	}        
}