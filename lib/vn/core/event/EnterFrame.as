package vn.core.event 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	/**
	 * Global EnterFrame provider for better performance and short hand
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * @features
	 * 		Support once listeners and each frame callbacks with parameters
	 * 
	 */
	public class EnterFrame 
	{
		public static var heart 	: Shape			= new Shape();//listen to EnterFrame Event
		private static var nextList : Dictionary	= new Dictionary();
		private static var eachList	: Dictionary	= new Dictionary();
		private static var eachCnt	: int;
		
		public static function onNext(f: Function, params : Array = null): void {
			heart.addEventListener(Event.ENTER_FRAME, _onNextFrame);
			nextList[f] = params;
		}
		
		public static function onEach(f: Function, params: Array = null): void {
			if (eachCnt == 0) heart.addEventListener(Event.ENTER_FRAME, _onEachFrame);
			eachList[f] = params;
		}
		
		public static function remove_onEach(f: Function): void {
			delete eachList[f]
		}
		
		private static function _onEachFrame(e:Event):void 
		{
			eachCnt = 0;
			for (var f: * in eachList) {
				eachCnt++;
				(f as Function).apply(null, eachList[f]);
			}
			if (eachCnt == 0) heart.removeEventListener(Event.ENTER_FRAME, _onEachFrame); //remove event if there are no items listened
		}
		
		private static function _onNextFrame(e: Event): void {
			heart.removeEventListener(Event.ENTER_FRAME, _onNextFrame);
			for (var f: * in nextList) {
				(f as Function).apply(null, nextList[f]);
				delete nextList[f];
			}
		}
	}

}