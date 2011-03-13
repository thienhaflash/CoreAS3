package vn.core.load.utils 
{
	import vn.core.load.core.LdVars;
	import vn.core.load.LdConst;
	import vn.core.load.SLoad;
	/**
	 * ...
	 * @author 
	 */
	public function loadURL(urlOrRequest : * , prioritize : String = LdPriority.QUEUE_FIRST, id: String = null, queue: String = 'main') : LdVars
	{
		return SLoad.getQueue(queue).add(urlOrRequest, prioritize, true);
	}
}