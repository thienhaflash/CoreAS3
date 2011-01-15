package vn.core 
{
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public class Injector 
	{
		public static function  getDefintion(def: String): Class {
			
		}
		
		public static function get Scroller(): Class {
			return getDefinitionByName('vn.ui.Scroller');
		}
	}

}