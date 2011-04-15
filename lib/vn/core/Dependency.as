package vn.core 
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
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
		
		public static function getAnInstance(src : * ): * {
			var cls : Class = getClass(src);
			return new cls();
		}
		
		public static function getClass(src : * ): Class {
			if (src is String) return getDefinitionByName(src) as Class;
			return getDefinitionByName(getQualifiedClassName(src)) as Class;
		}
		
		public static function getClassName(sample: Object): String {
			return getQualifiedClassName(sample);
		}
		
		public static function get aNewDispatcher(): IDispatcher {
			return getAnInstance(CLASS_Dispatcher);
		}
		
		
		
	}

}