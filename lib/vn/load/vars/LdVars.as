package vn.load.vars 
{
	import flash.events.Event;
	import vn.core.event.Dispatcher;
	import vn.load.constant.LdType;
	import vn.load.core.LdConfig;
	import vn.load.core.LdQueue;
	/**
	 * ...
	 * @author 
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