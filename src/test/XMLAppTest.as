package test 
{
	import vn.core.app.XMLApp;
	/**
	 * ...
	 * @author 
	 */
	public class XMLAppTest extends XMLApp
	{
		public function XMLAppTest() 
		{
			appConfigURL = 'assets/config.xml';
		}
		
		override public function initApp():void 
		{
			trace('initApp :: ', assets.jpg, assets.txt, assets.xml);
		}
		
	}

}