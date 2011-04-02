package vn.core 
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import vn.core.event.IDispatcher;
	/**
	 * ...
	 * @author 
	 */
	public class Dependency 
	{
		public static const CLASS_Dispatcher	: String = 'vn.core.event.Dispatcher';
		public static const CLASS_Buffer		: String = 'vn.optimize.Buffer';
		public static const CLASS_Cache			: String = 'vn.optimize.Cache';
		public static const CLASS_Pool			: String = 'vn.optimize.Pool';
		
		private static var dict		: Dictionary = new Dictionary(); // name to class
		
		public static function getAnInstance(className: String): * {
			var cls : Class = getClass(className);
			return new cls();
		}
		
		public static function getClass(className: String): Class {
			var cls : Class = dict[className];
			if (!cls) {
				cls = getDefinitionByName(className) as Class;
				if (cls) dict[className] = cls;
			}
			return cls;
		}
		
		
		public static function get aNewDispatcher(): IDispatcher {
			return getAnInstance(CLASS_Dispatcher);
		}
		
		
		
	}

}