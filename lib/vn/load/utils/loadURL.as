package vn.load.utils 
{
	import vn.load.core.LdConfig;
	import vn.load.LdConst;
	import vn.load.SLoad;
	/**
	 * shortHand, provides fastest way to load something
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * 
	 */
	public function loadURL(urlOrRequest : * , prioritize : String = LdPriority.QUEUE_FIRST, id: String = null, queue: String = 'main') : LdConfig
	{
		return SLoad.getQueue(queue).add(urlOrRequest, prioritize, true);
	}
}