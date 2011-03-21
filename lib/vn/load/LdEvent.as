package vn.load 
{
	import vn.core.event.Dispatcher;
	import vn.core.event.EventObject;
	import vn.load.core.LdQueue;
	import vn.load.core.LdConfig;
	import vn.load.vars.LdAudioVars;
	import vn.load.vars.LdDataVars;
	import vn.load.vars.LdGraphicVars;
	import vn.load.vars.LdVars;
	import vn.load.vars.LdVideoVars;
	/**
	 * ...
	 * @author 
	 */
	public class LdEvent extends EventObject
	{
		public static const ITEM_START		: String = 'START';
		public static const ITEM_INFO		: String = 'INFO'
		public static const ITEM_PROGRESS	: String = 'PROGRESS';
		public static const ITEM_ERROR		: String = 'ERROR';
		public static const ITEM_COMPLETE	: String = 'COMPLETE';
		public static const ITEM_STATUS		: String = 'STATUS';
		
		public static const QUEUE_ITEM_ADDED	: String = 'QUEUE_ITEM_ADDED';
		public static const QUEUE_ITEM_REMOVED	: String = 'QUEUE_ITEM_REMOVED';
		public static const QUEUE_PROGRESS		: String = 'QUEUE_PROGRESS';
		public static const QUEUE_STATUS		: String = 'QUEUE_STATUS';
		
		public var vars		: LdVars;
		
		public function LdEvent(source: Object) {
			super(source);
		}
		
		public function get audioVars(): LdAudioVars {
			return vars as LdAudioVars;
		}
		
		public function get videoVars(): LdVideoVars {
			return vars as LdVideoVars;
		}
		
		public function get graphicVars(): LdGraphicVars {
			return vars as LdGraphicVars;
		}
		
		public function get dataVars(): LdDataVars {
			return vars as LdDataVars;
		}
	}
}

