package vn.flash.event.shortcut 
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import vn.core.data.MultiKey;
	/**
	 * ...
	 * @author thienhaflash
	 */
	internal class _KEventVars 
	{
		public static var listeners : MultiKey = new MultiKey();
		
		public static function addParamsListener(source: IEventDispatcher, eventName: String, handler: Function, params: Array = null, priority: int = 0): void {
			
		}
	}
}