package vn.flash.event 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author thienhaflash (thienhaflash@gmail.com)
	 */
	internal interface IKEvent 
	{
		function add(source: IEventDispatcher, eventName: String, handler: Function, priority: int = 0): void;
		function remove(source: IEventDispatcher, eventName: String = null, handler: Function = null);
	}
	
}