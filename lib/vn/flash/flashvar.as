package vn.flash 
{
	import vn.flash.display.flashroot;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function flashvar(name: String, defaultValue: *): * 
	{
		var val  : * = flashroot.loaderInfo.parameters[name];
		return val == null ? defaultValue : val;
	}
}