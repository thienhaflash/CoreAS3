package vn.flash.event.shortcut 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function addLsn(source: IEventDispatcher, eventName: String, handler: Function, params: Array = null, priority: int = 0): void {
		if (!params) {
			source.addEventListener(eventName, handler, false, priority);
		} else {
			var f : Function = _KEventVars.listeners.getValue(source, eventName, handler);
			if (f != null) source.removeEventListener(eventName, f);
			
			f = function (e: Event): void { handler.apply(null, params) };
			_KEventVars.listeners.setValue(f, source, eventName, handler);
			source.addEventListener(eventName, f, false, priority);
		}
	}
}