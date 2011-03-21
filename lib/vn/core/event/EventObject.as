package vn.core.event 
{
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
	public class EventObject 
	{
		public var phase		: int;		//for multiple phase Event like Drag-Move-Drop
		public var type			: String;	//even name
		
		public var dispatcher	: Dispatcher;	//so user won't need to cast or use Object lookup
		public var source 		: Object;		//the one who tell dispatcher to dispatch
		public var userData		: Object;		//user attached data
		
		public function EventObject(source: Object, dispatcher: Dispatcher = null) {
			this.source		= source;
			this.dispatcher = dispatcher;
		}
	}
}