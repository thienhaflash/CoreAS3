package vn.core.load.core 
{
	import vn.core.event.Dispatcher;
	import vn.core.event.EventObject;
	import vn.core.load.vars.LdAudioVars;
	import vn.core.load.vars.LdDataVars;
	import vn.core.load.vars.LdGraphicVars;
	import vn.core.load.vars.LdVars;
	import vn.core.load.vars.LdVideoVars;
	/**
	 * EventObject used by all loader plugins and the LdQueue
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * 
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
		
		public function LdEvent(type: String) {
			super(type);
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

