package vn.core.load.core 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import vn.core.event.Dispatcher;
	import vn.core.event.EnterFrame;
	import vn.core.load.constant.LdPriority;
	import vn.core.load.constant.LdStatus;
	import vn.core.load.constant.LdType;
	import vn.core.load.LdEvent;
	/**
	 * ...
	 * @author 
	 */
	public class LdQueue 
	{
		public static var allQueues		: Dictionary	= new Dictionary();
		
		protected var _id				: * ;
		protected var _dict				: Dictionary;	/* <url|id> --> LdVars */
		protected var _queue			: Array;		/* of LdVars */
		protected var _extensions		: Object;		/* extension to Loader */
		protected var _dispatcher		: Dispatcher;	
		
		protected var _status			: String; /* queue status */
		protected var _currentItem		: LdVars; /* loading item */
		protected var _currentLoader	: LdBase; /* the loadler used to load currentItem */
		
		public function get currentItem() :LdVars { return _currentItem; }	
		public function get currentLoader()	:LdBase { return _currentLoader; }	
		public function get id() :* { return _id; }
		public function get dispatcher():Dispatcher { return _dispatcher; }
		
		public function get status():String { return _status; }
		
		public function LdQueue(queueId: *) {
			_id = queueId;
			allQueues[queueId] = this;
			_extensions = { };
			_dict	= new Dictionary();
			_dispatcher = new Dispatcher();
			
			_queue	= [];
			
			addLoader(new LdGraphic());
			addLoader(new LdAudio());
			addLoader(new LdVideo());
			addLoader(new LdData());
		}
		
	/********************
	 * 		SHORTHAND
	 *******************/	
		
		public function on_QUEUE_STATUS(handler: Function, params: Array = null): LdQueue {
			_dispatcher.addCallback(LdEvent.QUEUE_STATUS, handler, params);
			return this;
		}
		
		public function on_QUEUE_ITEM_ADDED(handler: Function, params: Array = null): LdQueue {
			_dispatcher.addCallback(LdEvent.QUEUE_ITEM_ADDED, handler, params);
			return this;
		}
		
	/********************
	 * 		API
	 *******************/
		
		public function addLoader(ld: LdBase, pExtension: String = null): void {
			/*
				User can overwrite the default extensions used for an ALoader instance (multiple ALoader instance of the same type)
				If pExtension was not specified, default values from ALoader class wil be used
				Lasted added ALoader will take control over extension registration (overwrite previous ones, if exist).
			*/
			ld.setQueue(this); //allow callback
			
			if (!pExtension) pExtension = ld.extension;
			var arr : Array = pExtension.split('|');
			var l : int = arr.length;
			for (var i: int = 0; i < l; i++) {
				_extensions[arr[i]] = ld;
			}
			_extensions[ld.type] = ld;
		}
		
		public function add(data: LdVars , priority: String = LdPriority.QUEUE_FIRST, autoResume: Boolean = true): LdVars {
			if (!data) { trace('trying to load a null URL'); return data; }
			
			if (data.url == null) data.url = data.request.url; //user used a request !
			data.queue = _id;
			_dict[data.url] = data;
			_dict[data.id] = data;
			
			var idx : int = _queue.indexOf(data); //TODO : OPTIMIZE !
			if (idx != -1) _queue.splice(idx, 1); //remove existed one to apply new priority rule
			
			switch (priority) {
				case LdPriority.QUEUE_FIRST	: _queue.unshift(data);	break;
				case LdPriority.QUEUE_LAST	: _queue.push(data);	break;
				case LdPriority.IMMEDIATELY	: 
					var oldStatus : String = _status;
					pause(); _queue.unshift(data);
					if (autoResume || oldStatus != LdStatus.QUEUE_PAUSED) loadNext(); break;
				//TODO : do something for ONLY_ME and PRELOAD
			}
			_dispatcher.dispatch(LdEvent.QUEUE_ITEM_ADDED);
			if (autoResume || _status == LdStatus.QUEUE_IDLE) EnterFrame.onNext(loadNext);
			//trace('autoResume ', autoResume, _status);
			return data;
		}
		
		public function get(url : String, id: String = null, autoNew : Boolean = false): LdVars {
			var ldi : LdVars = (id && _dict[id]) ? _dict[id] : _dict[url]; //try to overwrite same id first, if not existed, use URL
			
			if (autoNew && !ldi) {//not yet exist, create new !
				ldi = new LdVars(url, id);
				_dict[url] = ldi;
				if (id) _dict[id] = ldi;
			} else {
				//FIXME : what if ldi is currently at loading phase ? which means we must stop the loading first if it's the same id or just return the instance if it's using URL
				if (id) {//overwrite by same id - [remove old / create new] url association
					//trace('reuse id');
					delete _dict[ldi.url];
					_dict[url] = ldi;
					ldi.url = url;
				} else {//overwrite by same url - remove old id association, if existed
					//trace('reuse URL');
					if (ldi.id)  delete _dict[ldi.id];
					ldi.id = id;
				}
			}
			return ldi;
		}
		
		public function addURL(url: String, id: String = null): LdVars {
			return add(get(url, id, true));
		}
		
		public function remove(idOrURL: String): void {
			var ldi : LdVars = _dict[idOrURL];
			if (ldi) {//TODO : consider if there are a better way to reuse this ldi
				delete _dict[ldi.id];
				delete _dict[ldi.url];
				ldi.id = null;
				ldi.url = null; //will be skip when we process to this item : lazy way
				ldi.dispatcher.removeAllListenersOrCallbacks();
			}
		}
		
		public function empty(): LdQueue {
			_dict			= new Dictionary();
			_queue			= [];
			_currentItem	= null;
			setStatus(LdStatus.QUEUE_IDLE);
			return this;
		}
		
		public function pause(): LdQueue {
			cancelCurrent();
			setStatus(LdStatus.QUEUE_PAUSED);
			return this;
		}
		
		public function resume(): LdQueue {
			loadNext();
			return this;
		}
		
	/********************
	 * 		INTERNAL
	 *******************/
		
		private function getLd(url : String = null): LdBase {
			var type : String = url.slice(url.length - 4, url.length);
			return _extensions[type];
		}
		
		internal function loadNext(check: Boolean = true): void { /* internal to support callback from LdBase */
			if (check && _status == LdStatus.QUEUE_RUNNING) return; //skip if it's loading now
			
			var l : int		= _queue.length;
			_currentItem	= null;
			while (--l >= 0) {
				_currentItem = _queue.shift();
				if (_currentItem && _currentItem.url) break; //a valid item found !
			}
			
			if (_currentItem) {
				if (_currentItem.type == LdType.UNKNOWN) _currentItem.type = getLd(_currentItem.url) ? getLd(_currentItem.url).type : LdType.UNKNOWN;
				if (_currentItem.type != LdType.UNKNOWN) { //has Loader of the specified type
					_currentLoader = _extensions[_currentItem.type];
					_currentLoader.startLoad(_currentItem);
					setStatus(LdStatus.QUEUE_RUNNING);
				} else { // file is unknown type
					//TODO : SHOULD WE dispatch an error here ?
					trace(_currentItem.url + ' is UNKNOWN type so it can not be loaded ');
					loadNext(); //progress to next one
				}
			} else {
				setStatus(LdStatus.QUEUE_IDLE); //no more links to load
			}
		}
		
		private function cancelCurrent(): void {
			if (_currentLoader) {
				_currentLoader.stopLoad();
				_queue.unshift(_currentItem);
				_currentItem	= null;
				_currentLoader	= null;
			}
		}
		
		private function setStatus(s: String): void {
			if (_status != s) {
				_status = s;
				_dispatcher.dispatch(LdEvent.QUEUE_STATUS);
			}
		}
	}

}