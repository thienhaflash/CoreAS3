package vn.core.event 
{
	/**
	 * Interface for Dispatcher
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * 
	 */
	public interface IDispatcher 
	{
		function addListener(type: String, handler: Function, userData: Object = null, priority: int = 0, once: Boolean = false): void;
		
		function addListeners(types: * , handlers: * , userDatas: * = null, priorities: * = 0, onces : * = false): void;
		
		
		function addCallback(type: String, handler: Function, params: Array = null, priority: int = 0, once: Boolean = false): void;
		
		function addCallbacks(types: * , handlers: * , priorities: * = 0, onces : * = false, ...params): void;
		
		
		function removeListenerOrCallback(type: String, handler: Function): void;
		
		function removeListenersOrCallbacks(types: * , handlers: * ): void;
		
		function removeAllListenersOrCallbacks(): void;
		
		
		function dispatch(type: String): void;
		
		function injectEventObjectClass(eventObjectClass : Class = null): IDispatcher;
		
		function numListenerOrCallback(type: String): int;
	}

}