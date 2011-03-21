package vn.core.event 
{
	/**
	 * ...
	 * @author thienhaflash
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