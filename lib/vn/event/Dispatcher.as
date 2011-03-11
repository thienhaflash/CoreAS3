package vn.event 
{
	/**
	 * ...
	 * @author thienhaflash
	 */
	public class Dispatcher 
	{
		protected var _eventStores	: Object; //save references to AEventStore, each one a type
		protected var _eventObject	: EventObject; // the only one eventObject : no recursive dispatch allowed
		
		public function Dispatcher(eventObj: EventObject = null) {
			_eventStores = { };
			if (!_eventObject) _eventObject = new EventObject(this, this); //not pass eventObj by means extends from Dispatcher
		}
		
	/*************************
	 *		PUBLIC API
	 ************************/
		
		public function addListener(type: String, handler: Function, userData: Object = null, priority: int = 0, once: Boolean = false): void {
			var aes : AEventStore = _eventStores[type] || new AEventStore();
			_eventStores[type] = aes;
			if (!aes.dict[handler]) aes.add(new AListener(handler, userData, null, priority, once, false));
			//TODO : what else if registered ? update userData, priority, once ?
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
		
		public function hasListenerOrCallback(type: String): Boolean {
			var aes : AEventStore = _eventStores[type];
			return aes != null && aes.listeners.length > 0;
		}
		
		public function get eventObject():EventObject { return _eventObject; }
		
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
		
		private function informAListener(alsn: AListener):void 
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
		
	/*************************
	 * 	  SHORT HAND UTILS
	 ************************/
		
		public function addListeners(types: * , handlers: * , userDatas: * , priorities: * = 0, onces : * = false): void {
			var l : int = types is Array ? types.length : handlers.length;
			
			//this is just short-hand code, these type of code won't run everyframe, just once
			//so performance is not critical, we'd rather clear code than optimized
			for (var i : int = 0; i < l; i++) {
				addListener(	  types is Array		? types[i]		: types
								, handlers is Array		? handlers[i]	: handlers
								, userData is Array		? userDatas[i]	: userDatas
								, priorities is Array	? priorities[i]	: priorities
								, onces is Array		? onces[i]		: onces
							);
			}
		}
		
		public function addCallbacks(types: *, handlers: *, priority: * = 0, onces : * = false, ...params): void {
			var l : int = types is Array ? types.length : handlers.length;
			
			//this is just short-hand code, these type of code won't run everyframe, just once
			//so performance is not critical, we'd rather clear code than optimized
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
}

import flash.utils.Dictionary;
import flash.utils.getTimer;

class AListener { //consider pooling ?
	public var priority		: int;
	public var timeStamp	: int;
	
	public var handler		: Function;
	public var userData		: Object;
	public var params		: Array;
	public var isCallback	: Boolean;
	public var once			: Boolean;
	
	public function AListener(handler: Function, userData: Object, params: Array, priority: int, once: Boolean, isCallback: Boolean) {
		this.handler	= handler;
		this.userData	= userData;
		this.params		= params;
		this.priority	= priority;
		this.once		= once;
		this.isCallback	= isCallback;
		timeStamp		= getTimer();
	}
}

class AEventStore {
	public var dict			: Dictionary; //all handler --> AListener instance, use to check existance
	public var listeners	: Array; //of AListener, sorted by priorities and timeStamp, use to dispatch events
	
	public function AEventStore() {
		dict		= new Dictionary();
		listeners	= [];
	}
	
	public function add(alsn: AListener): AListener {
		var pos : int = findPosition(alsn);
		if (alsn != listeners[pos]) listeners.splice(pos, 0, alsn);
		return alsn;
	}
	
	public function remove(alsn: AListener): AListener {
		var pos : int = findPosition(alsn);
		if (alsn == listeners[pos]) listeners.splice(pos, 1); //found ! then remove it
		return alsn;
	}
	
	/* listeners should be sorted from Max to Min */
	public function findPosition(alsn: AListener): int {
		var l 	: int = 0;
		var r 	: int = listeners.length - 1;
		var m	: int = r >> 1;
		var lsn	: AListener;
		
		if (r == 0) return 0; //empty list
		
		/* priority	: mandatory term - bigger first, time : secondary term - smaller first */
		lsn = listeners[l];
		var lp	: int = lsn.priority;
		var lt	: int = lsn.timeStamp;
		lsn = listeners[r];
		var rp	: int = lsn.priority;
		var rt	: int = lsn.timeStamp;
		lsn = listeners[m];
		var mp	: int = lsn.priority;
		var mt	: int = lsn.timeStamp;
		
		var ap	: int = alsn.priority;
		var at	: int = alsn.timeStamp;
		
		if (lp < ap || (lp == ap && lt > at)) {//before the first one
			return 0;
		}
		
		if (rp > ap || (rp == ap && rt < at)) {
			return listeners.length;
		}
		
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
			mt = lsn.timeStamp;
		}
		return m; //nearest, bigger value
	}
}