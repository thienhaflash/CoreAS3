package vn.core.load 
{
	import vn.core.event.EventObject;
	import vn.core.load.core.LdQueue;
	import vn.core.load.core.LdVars;
	/**
	 * ...
	 * @author 
	 */
	public class LdEvent extends EventObject
	{
		public static const ITEM_START		: String = 'START';
		public static const ITEM_INFO		: String = 'INFO'
		public static const ITEM_PROGRESS	: String = 'PROGRESS';
		public static const ITEM_ERROR		: String = 'ERROR';
		public static const ITEM_COMPLETE	: String = 'COMPLETE';
		public static const ITEM_STATUS		: String = 'STATUS';
		
		public static const QUEUE_ITEM_ADDED	: String = 'QUEUE_ITEM_ADDED';
		public static const QUEUE_ITEM_REMOVED	: String = 'QUEUE_ITEM_REMOVED';
		public static const QUEUE_PROGRESS		: String = 'QUEUE_PROGRESS';
		public static const QUEUE_STATUS		: String = 'QUEUE_STATUS';
		
		//public var vars		: LdVars;
		//public var queue	: LdQueue;
		
		public function LdEvent() {
			super(null, null); //FIXME : fix pass the correct parameters
		}
	}
}

