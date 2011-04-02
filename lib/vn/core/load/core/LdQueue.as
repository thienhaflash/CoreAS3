package vn.core.load.core 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import vn.core.Dependency;
	import vn.core.event.Dispatcher;
	import vn.core.event.EnterFrame;
	import vn.core.event.IDispatcher;
	import vn.core.load.constant.LdPriority;
	import vn.core.load.constant.LdStatus;
	import vn.core.load.constant.LdType;
	import vn.core.load.plugins.LdAudio;
	import vn.core.load.plugins.LdData;
	import vn.core.load.plugins.LdGraphic;
	import vn.core.load.plugins.LdVideo;
	import vn.core.load.vars.LdAudioVars;
	import vn.core.load.vars.LdDataVars;
	import vn.core.load.vars.LdGraphicVars;
	import vn.core.load.vars.LdVideoVars;
	/**
	 * LoaderQueue to manage asset loading with plugin architecture
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * @features
	 * 		Support Dispatcher and shortHand
	 * 		Support add / remove / pause / resume / empty functions
	 * 		Plugin architecture that we can add new Loader types anytime
	 * 
	 */
	public class LdQueue 
	{
		public static var allQueues		: Dictionary	= new Dictionary();
		
		public static function getQueue(id: *, autoNew : Boolean): LdQueue {
			var q : LdQueue = allQueues[id];
			if (!q && autoNew) q = new LdQueue(id);
			return q;
		}
		
		protected var _dict				: Dictionary;	/* <url|id> --> LdConfig */
		protected var _queue			: Array;		/* of LdConfig */
		protected var _extensions		: Object;		/* extension to Loader */
		
		public function LdQueue(queueId: *) {
			_id = queueId;
			allQueues[queueId] = this;
			_extensions = { };
			_dict	= new Dictionary();
			_dispatcher = Dependency.aNewDispatcher.injectEventObject(new LdEvent(this));
			
			_queue	= [];
			
			addLoader(new LdGraphic());
			addLoader(new LdAudio());
			addLoader(new LdVideo());
			addLoader(new LdData());
		}
		
	/********************
	 * 		SHORTHAND
	 *******************/	
		
		public function on_QUEUE_STATUS(handler: Function, params: Array = null, once: Boolean = false): LdQueue {
			_dispatcher.addCallback(LdEvent.QUEUE_STATUS, handler, params, 0, once);
			return this;
		}
		
		public function on_QUEUE_ITEM_ADDED(handler: Function, params: Array = null, once: Boolean = false): LdQueue {
			_dispatcher.addCallback(LdEvent.QUEUE_ITEM_ADDED, handler, params, 0, once);
			return this;
		}
		
	/********************
	 * 		GETTERS
	 *******************/	
		
		protected var _id				: * ;
		protected var _dispatcher		: IDispatcher;	
		
		protected var _status			: String; /* queue status */
		protected var _currentConfig	: LdConfig; /* loading item */
		protected var _currentLoader	: LdBase; /* the loadler used to load currentItem */
		
		public function get id():* { return _id; }
		public function get dispatcher():IDispatcher { return _dispatcher; }
		
		public function get status():String { return _status; }
		public function get currentConfig():LdConfig { return _currentConfig; }	
		public function get currentLoader():LdBase { return _currentLoader; }
		
		public function get audioVars(): LdAudioVars {
			return _currentLoader.vars as LdAudioVars;
		}
		
		public function get videoVars(): LdVideoVars {
			return _currentLoader.vars as LdVideoVars;
		}
		
		public function get graphicVars(): LdGraphicVars {
			return _currentLoader.vars as LdGraphicVars;
		}
		
		public function get dataVars(): LdDataVars {
			return _currentLoader.vars as LdDataVars;
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
		
		public function add(data: LdConfig , priority: String = null, autoResume: Boolean = true): LdConfig {
			if (!data) { trace('trying to load a null URL'); return data; }
			
			if (priority == null) priority = LdPriority.QUEUE_FIRST;
			
			if (data.url == null) data.url = data.request.url; //user used a request !
			data.queue = _id;
			_dict[data.url] = data;
			_dict[data.id]	= data;
			
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
		
		public function get(url : String, id: String = null, autoNew : Boolean = false): LdConfig {
			var ldi : LdConfig = (id && _dict[id]) ? _dict[id] : _dict[url]; //try to overwrite same id first, if not existed, use URL
			
			if (autoNew && !ldi) {//not yet exist, create new !
				ldi = new LdConfig(url, id);
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
		
		public function addURL(url: String, id: String = null, priority: String = null): LdConfig {
			return add(get(url, id, true), priority);
		}
		
		public function remove(idOrURL: String): void {
			var ldi : LdConfig = _dict[idOrURL];
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
			_currentConfig	= null;
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
			_currentConfig	= null;
			while (--l >= 0) {
				_currentConfig = _queue.shift();
				if (_currentConfig && _currentConfig.url) break; //a valid item found !
			}
			
			if (_currentConfig) {
				if (_currentConfig.type == LdType.UNKNOWN) _currentConfig.type = getLd(_currentConfig.url) ? getLd(_currentConfig.url).type : LdType.UNKNOWN;
				if (_currentConfig.type != LdType.UNKNOWN) { //has Loader of the specified type
					_currentLoader = _extensions[_currentConfig.type];
					_currentLoader.startLoad(_currentConfig);
					setStatus(LdStatus.QUEUE_RUNNING);
				} else { // file is unknown type
					//TODO : SHOULD WE dispatch an error here ?
					trace(_currentConfig.url + ' is UNKNOWN type so it can not be loaded ');
					loadNext(); //progress to next one
				}
			} else {
				setStatus(LdStatus.QUEUE_IDLE); //no more links to load
			}
		}
		
		private function cancelCurrent(): void {
			if (_currentLoader) {
				_currentLoader.stopLoad();
				_queue.unshift(_currentConfig);
				_currentConfig	= null;
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