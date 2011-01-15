package vn.core.mouse 
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public class Behavior 
	{
		public var targetDO : InteractiveObject;
		public var manager	: Object;
		public var update	: int; //times called counted
		public var event	: Event; //attached MouseEvent
		
		
	}

}