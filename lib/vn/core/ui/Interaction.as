package vn.core.ui 
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import vn.core.Dispatcher;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public class Interaction 
	{
		public static const MOUSE_OVER_OUT	: String;
		public static const MOUSE_DOWN_UP	: String;
		public static const MOUSE_SCROLL	: String;
		
		public static const CLICK			: String;
		public static const DOUBLE_CLICK	: String;
		public static const DRAG_DROP_THROW	: String;
		
		//js HELP ?
		public static const RIGHT_CLICK		: String;
		public static const MMB_CLICK		: String;
		
		public static function add(target: Object, behavior : String, callback: Function): void {
			//do something here
		}
		
		public static function remove(target: Object, behavior: String, callback: Function): void {
			//do remove events here
		}
	}
}

import flash.display.InteractiveObject;
import flash.events.MouseEvent;

class EventObject {
	public var targetDO : InteractiveObject;
	public var manager	: Object;
	public var update	: int; //times called counted
	public var event	: MouseEvent; //attached MouseEvent
}