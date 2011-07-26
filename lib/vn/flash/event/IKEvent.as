package vn.flash.event 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author thienhaflash (thienhaflash@gmail.com)
	 */
	public interface IKEvent 
	{
		/*** EVENT + PARAMS */
		function addLsn(source: IEventDispatcher, eventName: String, handler: Function, priority: int = 0): IKEvent;
		function removeLsn(source: IEventDispatcher, eventName: String = null, handler: Function = null): IKEvent;
		
		function multiAddLsn(sources: * , eventNames: * , handlers: * , priorities: * = 0): IKEvent;
		function multiRemoveLsn(sources: * , eventNames: * = null, handlers: * = null): IKEvent;
		
		/** ENTERFRAME **/
		function onEachFrame(f: Function, params: Array = null): void;
		function onNextFrame(f: Function, params : Array = null) : void;
		function removeOnEachFrame(f: Function): void;
		function removeOnNextFrame(f: Function): void;
		
		/** TIMER **/
		function delayCall(f: Function, delay: Number): void;
		function killDelayCall(f: Function): void;
	}
}