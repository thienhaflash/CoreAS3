package vn.flash.event.shortcut 
{
	import flash.events.IEventDispatcher;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function remLsn(source: IEventDispatcher, eventName: String = null, handler: Function = null): void
	{
		if (eventName == null || handler == null) {
			var arr : Array = [source];
			if (eventName) arr.push(eventName);
			if (handler != null) arr.push(handler);
			
			var data	: Object =  _KEventVars.listeners.removeValues(arr, false);
			var tmp		: Array;
			for (var s : String in data) {
				tmp = _KEventVars.listeners.break2Key(s);
				source.removeEventListener(tmp[1], data[s]); // 0 : source, 1: eventName, 2: function
			}
		} else {
			var f : Function = _KEventVars.listeners.removeValue(source, eventName, handler);
			if (f != null) {
				source.removeEventListener(eventName, f);
			} else {
				source.removeEventListener(eventName, handler);
			}
		}
	}
}