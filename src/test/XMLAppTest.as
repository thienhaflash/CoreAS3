package test 
{
	import vn.core.app.XMLApp;
	import vn.core.optimize.Buffer;
	/**
	 * ...
	 * @author 
	 */
	public class XMLAppTest extends XMLApp
	{
		public function XMLAppTest() 
		{
			var a : Buffer;
			appConfigURL = 'assets/config.xml';
		}
		
		override public function initApp():void 
		{
			trace('initApp :: ', assets.jpg, assets.txt, assets.xml);
		}
		
	}

}