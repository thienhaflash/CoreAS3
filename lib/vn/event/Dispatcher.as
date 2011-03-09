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
		}
		
		final public function addListeners(types: *, handlers: *, userDatas: *, priorities: * = 0, once: * = false): void {
			
		}
		
		final public function addCallbacks(types: *, handlers: *, params: Array = null, priority: * = 0, once: * = false): void {
			
		}
		
		final public function addListener(type: String, handler: Function, userData: Object = null, priority: int = 0, once: Boolean = false): void {
			
		}
		
		final public function addCallback(type: String, handler: Function, params: Array = null, priority: int = 0, once: Boolean = false): void {
			
		}
		
		final public function removeListenerOrCallback(type: String, handler: Function): void {
			
		}
		
		final public function hasListenerOrCallback(type: String): Boolean {
			var aes : AEventStore = _eventStores[type];
			return aes != null && aes.listeners.length > 0;
		}
		
		protected var _isDispatching : Boolean;
		
		final public function dispatch(type: String, phase: int = 0 ): void {
			if (_isDispatching) {
				trace('recursive dispatch not allowed !');
				return;
			} else {
				_isDispatching = true;
				_eventObject.type	= type;
				_eventObject.phase	= phase;
				
				//loop through the AEventStore for eventType add callback, pass EventObject or params by
				var aes : AEventStore = _eventStores[type];
				if (aes) aes.listeners.forEach(informAListener);
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
		}
		
		final public function get eventObject():EventObject { return _eventObject; }
	}
}
import flash.utils.Dictionary;

class AListener { //consider pooling ?
	public var priority		: int;
	public var timeStamp	: int;
	
	public var handler		: Function;
	public var userData		: Object;
	public var params		: Array;
	public var isCallback	: Boolean;
	public var once			: Boolean;
}

class AEventStore {
	public var dict			: Dictionary; //all handler --> AListener instance, use to check existance
	public var listeners	: Array; //of AListener, sorted by priorities and timeStamp, use to dispatch events
	
	public function add(alsn: AListener): AListener {
		//use binary search to find position and inject in
		return alsn;
	}
	
	public function remove(alsn: AListener): AListener {
		//use binary search to find position and split out
		return alsn;
	}
}