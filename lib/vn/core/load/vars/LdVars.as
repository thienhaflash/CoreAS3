package vn.core.load.vars 
{
	import flash.events.Event;
	import vn.core.event.Dispatcher;
	import vn.core.load.core.LdConfig;
	/**
	 * base class for all loader plugin vars
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * 
	 */
	public class LdVars 
	{
		public var status			: String;
		public var bytesLoaded		: int;
		public var bytesTotal		: int;
		public var percent			: Number;
		public var event			: Event;
		public var loadedContent	: * ;
		public var config			: LdConfig;
		
	/********************
	 * 	DATA MAPPER
	 *******************/
			
		public function get type():String { return config.type; }
		public function get url(): String { return config.url };
		public function get id(): String { return config.id };
		public function get dispatcher(): Dispatcher { return config.dispatcher };
	}
}