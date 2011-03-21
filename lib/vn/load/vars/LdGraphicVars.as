package vn.load.vars 
{
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import vn.load.constant.LdType;
	/**
	 * LdGraphicVars : variables used by LdGraphic plugin and used to ensure strong typing to end users
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * 
	 */
	public class LdGraphicVars extends LdVars
	{
		public var loader		: Loader;
		public var context		: LoaderContext = new LoaderContext();
	}

}