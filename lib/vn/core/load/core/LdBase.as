package vn.core.load.core 
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import vn.core.event.Dispatcher;
	import vn.core.load.constant.LdStatus;
	import vn.core.load.constant.LdType;
	import vn.core.load.core.LdVars;
	import vn.core.load.LdEvent;
	/**
	 * ...
	 * @author 
	 */
	public class LdBase 
	{
		protected var _stopAt		: Number;
		protected var _dispatcher	: Dispatcher;
		
	/****************************
	 * 			API
	 ***************************/
		
		public function startLoad(data: LdVars): void {//do parse ?
			//check if it's calling while this is dispatching (?)
			_vars = data;
			_dispatcher = data.dispatcher;
			
			stopLoad();//check if it's loading
			_startLoad();
			
			_dispatcher.dispatch(LdEvent.ITEM_START);
			_status = LdStatus.ITEM_LOADING;
			_dispatcher.dispatch(LdEvent.ITEM_STATUS);
		}
	 
		public function stopLoad(): void {
			//check if it's calling while this is dispatching (?)
			_stopLoad();
		}
		
		public function get extension(): String { return ''; }	
		
	/****************************
	 * 		INFORMATION
	 ***************************/
		
		protected var _status			: String;
		protected var _bytesLoaded		: int;
		protected var _bytesTotal		: int;
		protected var _percent			: Number;
		protected var _event			: Event;
		protected var _loadedContent	: * ;
		protected var _vars				: LdVars;
		
		//protected var _id				: String;
		//protected var _url			: String;
		//protected var _queue			: String;
		
		public function get status():String { return _status; }
		
		public function get bytesLoaded():int {	return _bytesLoaded; }
		
		public function get bytesTotal():int { return _bytesTotal; }
		
		public function get percent():Number { return _percent;	}
		
		public function get event():Event {	return _event; }
		
		public function get loadedContent():* {	return _loadedContent; }
		
		
		public function get id():String { return _vars.id; }
		
		public function get url():String { return _vars.url; }
		
		public function get queue():String { return _vars.queue; }
		
		public function get type(): String { return LdType.UNKNOWN; }
		
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
			_event		= e;
			_percent	= 1;
			
			_dispatcher.dispatch(LdEvent.ITEM_COMPLETE);
			_status = LdStatus.ITEM_LOADED;
			_dispatcher.dispatch(LdEvent.ITEM_STATUS);
		}
		
		protected function _onProgress(e:ProgressEvent):void
		{
			_event			= e;
			_bytesLoaded	= e.bytesLoaded;
			_bytesTotal		= e.bytesTotal;
			_percent		= e.bytesLoaded / e.bytesTotal;
			//TODO		: check stopAt and do stop
			
			_dispatcher.dispatch(LdEvent.ITEM_PROGRESS);
		}
		
		protected function _onError(e:Event):void 
		{
			_event = e;
			
			_dispatcher.dispatch(LdEvent.ITEM_ERROR);
			_status = LdStatus.ITEM_ERROR;
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
			_event = e;
			_dispatcher.dispatch(LdEvent.ITEM_INFO);
		}
	}

}