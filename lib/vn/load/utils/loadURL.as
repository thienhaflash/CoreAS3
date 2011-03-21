package vn.load.utils 
{
	import vn.load.core.LdConfig;
	import vn.load.LdConst;
	import vn.load.SLoad;
	/**
	 * ...
	 * @author 
	 */
	public function loadURL(urlOrRequest : * , prioritize : String = LdPriority.QUEUE_FIRST, id: String = null, queue: String = 'main') : LdConfig
	{
		return SLoad.getQueue(queue).add(urlOrRequest, prioritize, true);
	}
}