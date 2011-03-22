package vn.core.load.core 
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import vn.core.event.Dispatcher;
	import vn.core.load.constant.LdStatus;
	import vn.core.load.constant.LdType;
	import vn.core.load.vars.LdAudioVars;
	import vn.core.load.vars.LdDataVars;
	import vn.core.load.vars.LdGraphicVars;
	import vn.core.load.vars.LdVars;
	import vn.core.load.vars.LdVideoVars;
	/**
	 * Base class for all Loader plugins
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * 
	 */
	public class LdBase 
	{
		protected var _config		: LdConfig;
		protected var _queue		: LdQueue;
		
		public function get vars(): LdVars {
			return null;
		}
		
		internal function setQueue(value: LdQueue):void { _queue = value; }
		public function get type():String { return LdType.AUDIO; }
		
	/****************************
	 * 			API
	 ***************************/
		
		protected var _dispatcher	: Dispatcher;
		
		public function startLoad(data: LdConfig): void {//do parse ?
			//check if it's calling while this is dispatching (?)
			stopLoad();//check if it's loading
			
			vars.config	= data;
			_config			= data;
			_dispatcher		= data.dispatcher;
			
			_startLoad();
			
			_dispatcher.dispatch(LdEvent.ITEM_START);
			vars.status = LdStatus.ITEM_LOADING;
			_dispatcher.dispatch(LdEvent.ITEM_STATUS);
		}
	 
		public function stopLoad(): void {
			//check if it's calling while this is dispatching (?)
			_stopLoad();
		}
		
		public function get extension(): String { return ''; }	
		
	/****************************
	 * 		OVERRIDE METHODS
	 ***************************/
		
		protected function _stopLoad():void { }
		
		protected function _startLoad(): void { }
		
	/****************************
	 * 		EVENT HANDLERS
	 ***************************/
			
		protected function _onComplete(e:Event):void 
		{
			vars.event		= e;
			vars.percent	= 1;
			
			_dispatcher.dispatch(LdEvent.ITEM_COMPLETE);
			vars.status = LdStatus.ITEM_LOADED;
			_dispatcher.dispatch(LdEvent.ITEM_STATUS);
			
			_queue.loadNext(false); //consider wait 1 more frame ?
		}
		
		protected function _onProgress(e:ProgressEvent):void
		{
			if (e) {
				vars.event			= e;
				vars.bytesLoaded	= e.bytesLoaded;
				vars.bytesTotal		= e.bytesTotal;
				vars.percent		= e.bytesLoaded / e.bytesTotal;
			}
			
			//TODO		: check stopAt and do stop
			_dispatcher.dispatch(LdEvent.ITEM_PROGRESS);
		}
		
		protected function _onError(e:Event):void 
		{
			vars.event = e;
			
			_dispatcher.dispatch(LdEvent.ITEM_ERROR);
			vars.status = LdStatus.ITEM_ERROR;
			_dispatcher.dispatch(LdEvent.ITEM_STATUS);
			
			/* 	User may have other files in the list, so once callback's trigger fired, the new link is loaded in 
				and started to load, which make callback.data point to another object before we doing the delete
				So we need to create a temporary obj to save the reference to the old object and do deleteVars
				There can be a rare case when user decided to change the object's link and push it into the queue inside 
				the ERROR handler. After that, the AmiLoaderImpl calls loadNext which add references to the new loader
				This case we must not delete these new references :: Only do deleteVars if callback.data is changed
				If there is nothing start, callback.data == null, will also different from obj, so we can safely delete from Obj
			 */
		}
		
		protected function _onInfo(e:Event):void 
		{
			vars.event = e;
			_dispatcher.dispatch(LdEvent.ITEM_INFO);
		}
	}

}