package vn.core.load.utils 
{
	import vn.core.load.constant.LdPriority;
	import vn.core.load.core.LdConfig;
	import vn.core.load.core.LdQueue;
	/**
	 * shortHand, provides fastest way to load something
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * 
	 */
	public function loadURL(url : *, id: String = null, prioritize : String = LdPriority.QUEUE_FIRST, queue: String = 'main') : LdConfig
	{
		return LdQueue.getQueue(queue, true).addURL(url, id, prioritize);
	}
}