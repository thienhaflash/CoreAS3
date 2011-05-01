package vn.core.event 
{
	import flash.events.Event;
	/**
	 * Base EventObject used with Dispatcher
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * @features
	 * 		Support userdata, source, dispatcher, type and phase
	 * 
	 */
	public class EventObject extends Event
	{
		public var dispatcher	: IDispatcher;	//so user won't need to cast or use Object lookup
		public var source 		: Object;		//the one who tell dispatcher to dispatch
		public var userData		: Object;		//user attached data
		
		public function EventObject(type: String, cancelable : Boolean = false ) {
			super(type, false, cancelable);
		}
		
	}
}