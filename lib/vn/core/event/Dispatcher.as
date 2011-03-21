package vn.core.event 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	/**
	 * A better AS3 Event system - fast, stable and full features
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * @features
	 * 		Support both Listeners (call handler with eventObject) and Callbacks (call handler with params)
	 * 		Support priority with LOW (<0) and HIGH (>0) or NORMAL (=0, default)
	 * 		Support custom dispatching phase (first = 0, update = n, last = -1)
	 * 		Get the number of listeners or callback for a specific event type
	 * 		Batch add / remove Listeners / Callbacks by shorthand utils
	 * 
	 * @techniques
	 * 		Binary search based on priority (primary) and id (secondary) making adding / removing listeners blazing fast
	 * 		Composition style, user can both extends from dispatcher or use it as a component
	 * 
	 * @todo
	 * 		Consider pooling for AListener
	 * 		Consider explicit overwriting support if existed { event + handlers } found
	 * 
	 */
		
	public class Dispatcher implements IDispatcher
	{
		protected var _eventStores	: Object; //save references to AEventStore, each one a type
		protected var _eventObject	: EventObject; // the only one eventObject : no recursive dispatch allowed
		
		public function Dispatcher(eventObj: EventObject = null) {
			_eventStores = { };
			if (!_eventObject) {
				_eventObject = new EventObject(this, this); 
			} else {
				_eventObject.dispatcher = this;
			}
		}
		
	/*************************
	 *		PUBLIC API
	 ************************/
		
		public function addListener(type: String, handler: Function, userData: Object = null, priority: int = 0, once: Boolean = false): void {
			var aes : AEventStore = _eventStores[type] || new AEventStore();
			_eventStores[type] = aes;
			if (!aes.dict[handler]) aes.add(new AListener(handler, userData, null, priority, once, false));
			//TODO : what else if registered ? update userData, priority, once ? - temporary doing nothing
		}
		
		public function addCallback(type: String, handler: Function, params: Array = null, priority: int = 0, once: Boolean = false): void {
			var aes : AEventStore = _eventStores[type] || new AEventStore();
			_eventStores[type] = aes;
			if (!aes.dict[handler]) aes.add(new AListener(handler, null, params, priority, once, true));
		}
		
		public function removeListenerOrCallback(type: String, handler: Function): void {
			var aes		: AEventStore = _eventStores[type];
			var alsn	: AListener = aes.dict[handler];
			if (alsn) aes.remove(alsn);
		}
		
		public function numListenerOrCallback(type: String): int {
			var aes : AEventStore = _eventStores[type];
			return aes != null ? aes.listeners.length : 0;
		}
		
		public function removeAllListenersOrCallbacks(): void {
			_eventStores = { };
		}
		
		public function get eventObject():EventObject { return _eventObject; }
		
		public function get isDispatching():Boolean { return _isDispatching; }
		
	/*************************
	 * 		INTERNAL
	 ************************/	
		
		protected var _isDispatching	: Boolean;
		protected var _tmpAES			: AEventStore; /* temporary use by dispatch only */
		
		public function dispatch(type: String, phase: int = 0 ): void {
			if (_isDispatching) {
				trace('recursive dispatches not allowed !');
				return;
			} else {
				_isDispatching = true;
				_eventObject.type	= type;
				_eventObject.phase	= phase;
				_tmpAES = _eventStores[type];
				if (_tmpAES) _tmpAES.listeners.forEach(informAListener);
				_isDispatching = false;
			}
		}
		
		private function informAListener(alsn: AListener, idx: int, arr: Array):void 
		{
			if (alsn.isCallback) {
				_eventObject.userData = null; //clear userData previosly attached
				alsn.handler.apply(null, alsn.params);
			} else {
				_eventObject.userData = alsn.userData; //inject userData
				alsn.handler(_eventObject);
			}
			if (alsn.once) _tmpAES.remove(alsn);
		}
		
	/********************************************************************************************
	 *	SHORT HAND UTILS
	 * 	These type of codes won't run every frames, just once, so performance is not critical
	 *  we'd rather clear code than optimized
	 ********************************************************************************************/
		
		public function addListeners(types: * , handlers: * , userDatas: * = null, priorities: * = 0, onces : * = false): void {
			var l : int = types is Array ? types.length : handlers.length;
			for (var i : int = 0; i < l; i++) {
				addListener(	  types is Array		? types[i]		: types
								, handlers is Array		? handlers[i]	: handlers
								, userDatas is Array	? userDatas[i]	: userDatas
								, priorities is Array	? priorities[i]	: priorities
								, onces is Array		? onces[i]		: onces
							);
			}
		}
		
		public function addCallbacks(types: *, handlers: *, priorities: * = 0, onces : * = false, ...params): void {
			var l : int = types is Array ? types.length : handlers.length;
			var sameParams : Boolean = params.length == 1;
			for (var i : int = 0; i < l; i++) {
				addCallback(	  types is Array		? types[i]		: types
								, handlers is Array		? handlers[i]	: handlers
								, sameParams			? params[0]		: params[i]
								, priorities is Array	? priorities[i] : priorities
								, onces is Array		? onces[i]		: onces
							);
			}
		}
		
		public function removeListenersOrCallbacks(types: *, handlers: *): void {
			var l : int = types is Array ? types.length : handlers.length;
			for (var i : int = 0; i < l; i++) {
				removeListenerOrCallback(	 types is Array		? types[i]		: types
											, handlers is Array	? handlers[i]	: handlers
							);
			}
		}
	}
}

import flash.utils.Dictionary;

class AListener {
	public var priority		: int;
	public var id			: int;
	
	public var handler		: Function;
	public var userData		: Object;
	public var params		: Array;
	public var isCallback	: Boolean;
	public var once			: Boolean;	
	private static var idCounter : int;
	
	public function AListener(handler: Function, userData: Object, params: Array, priority: int, once: Boolean, isCallback: Boolean) {
		this.handler	= handler;
		this.userData	= userData;
		this.params		= params;
		this.priority	= priority;
		this.once		= once;
		this.isCallback	= isCallback;
		id				= idCounter++;
	}
	
	public function toString(): String {
		return '[AListener ' + priority + '-' + id + ']';
	}
}

class AEventStore {
	public var dict			: Dictionary; //all handler --> AListener instance, use to check existance
	public var listeners	: Array; //of AListener, sorted by priorities and id, use to dispatch events
	
	public function AEventStore() {
		dict		= new Dictionary();
		listeners	= [];
	}
	
	public function add(alsn: AListener): AListener {
		var pos : int = findPosition(alsn);
		if (alsn != listeners[pos]) {
			dict[alsn.handler] = alsn;
			listeners.splice(pos, 0, alsn);
		}
		//trace('add: ', listeners);
		return alsn;
	}
	
	public function remove(alsn: AListener): AListener {
		var pos : int = findPosition(alsn, true);
		//trace('remove pos = ', pos, ' with id : ', alsn.id);
		if (alsn == listeners[pos]) {
			dict[alsn.handler] = null;
			listeners.splice(pos, 1); //found ! then remove it
		}
		return alsn;
	}
	
	
	/**
	 * find the gaps to put item in, or the item position itself
	 * @param	alsn the item to find
	 * @param	findItem find the gap to insert item in (0..length) or find the item to remove (0..length-1)
	 * @return the position of the gap or the position of the item
	 */
	public function findPosition(alsn: AListener, findItem : Boolean = false): int {
		var l 	: int = 0;
		var r 	: int = listeners.length - 1;
		var m	: int = (r - l) >> 1;
		var lsn	: AListener;
		
		if (r < l) return l; //empty list
		
		/* priority	: mandatory term - bigger first, id : secondary term - smaller first */
		lsn = listeners[l];
		var lp	: int = lsn.priority;
		var lt	: int = lsn.id;
		lsn = listeners[r];
		var rp	: int = lsn.priority;
		var rt	: int = lsn.id;
		lsn = listeners[m];
		var mp	: int = lsn.priority;
		var mt	: int = lsn.id;
		
		var ap	: int = alsn.priority;
		var at	: int = alsn.id;
		
		if (ap > lp || (lp == ap && (at < lt || (at == lt && findItem)))) return 0; //before the first one
		if (ap < rp || (rp == ap && (at > rt || (at == rt && findItem)))) return findItem ? listeners.length-1 : listeners.length; //after the last one
		
		while (l < m) {
			if (ap == mp && at == mt) return m; //correct value
			if (ap > mp || (ap == mp && at < mt)) {//left
				r	= m;
				rp	= mp;
				rt	= mt;
			} else {//right
				l	= m;
				lp	= mp;
				lt	= mt;
			}
			m = (r + l) >> 1;
			lsn = listeners[m];
			mp = lsn.priority;
			mt = lsn.id;
		}
		return findItem ? m : m + 1; //nearest, bigger value
	}
}