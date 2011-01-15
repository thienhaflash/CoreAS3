package vn.core 
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * @version 0.1.3
	 * @author thienhaflash
	 * @note Support only one params array for each callback - multiple calls will overwrite each other
	 * 
	 * @update 13 Nov 2009 (0.1.2)
	 * 		Changed completely to customed eventDispatcher to fit the needs
	 *  	Use just as the same as the old AmiDispatcher but without hassle
	 * 		Support abitrary number of parameters/types through params Array
	 * 		> 180% Faster than flash's built in EventDispatcher
	 * 
	 */
	public class Dispatcher
	{
		protected var _evtTypes	 :	Object = {};
		
		final public function addLsn(type: String, f: Function, params: Array = null): void {
			var dict : Dictionary = _evtTypes[type];
			if (dict == null) {
				dict = new Dictionary();
				_evtTypes[type] = dict;
			}
			dict[f] = params;
		}
		
		final public function remAllLsn(): void {
			_evtTypes = { };
		}
		
		final public function remLsn(type: String, f: Function): void {
			var dict : Dictionary = _evtTypes[type];
			if (dict[f]) delete dict[f];
		}
		
		final public function dispatch(type: String): void {
			if (_skipEvent) return;
			
			var dict : Dictionary = _evtTypes[type];
			if (dict) {
				for (var f: * in dict) {
					f.apply(f, dict[f]);
				}
			}
		}
		
		protected var _skipEvent	: Boolean;
		
		final public function get skipEvent():Boolean { return _skipEvent; }
		
		final public function set skipEvent(value:Boolean):void 
		{
			_skipEvent = value;
		}
	}
	
}