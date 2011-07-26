package vn.flash.event 
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import vn.manager.infs.IKEvent;
	/**
	 * ...
	 * @author thienhaflash
	 */
	internal class _KEventImpl implements IKEvent
	{
		/*** EVENT + PARAMS */
		public function addLsn(source:IEventDispatcher, eventName:String, handler:Function, priority:int = 0):IKEvent {
			source.addEventListener(eventName, handler, false, priority);
		}
		
		public function removeLsn(source:IEventDispatcher, eventName:String = null, handler:Function = null):IKEvent 
		{
			
		}
		
		public function multiAddLsn(sources:*, eventNames:*, handlers:*, priorities:* = 0):IKEvent 
		{
			
		}
		
		public function multiRemoveLsn(sources:*, eventNames:* = null, handlers:* = null):IKEvent 
		{
			
		}
		
		/*** ENTERFRAME */
		
		public function onEachFrame(f:Function, params:Array = null):void 
		{
			
		}
		
		public function onNextFrame(f:Function, params:Array = null):void 
		{
			
		}
		
		public function removeOnEachFrame(f:Function):void 
		{
			
		}
		
		public function removeOnNextFrame(f:Function):void 
		{
			
		}
		
		/*** TIMER */
		
		public function delayCall(f:Function, delay:Number):void 
		{
			
		}
		
		public function killDelayCall(f:Function):void 
		{
			
		}
	}
}