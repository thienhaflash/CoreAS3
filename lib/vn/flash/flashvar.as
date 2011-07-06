package vn.flash 
{
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function flashvar(pName: String, pDefault: *): * 
	{
		var val  : * = flashroot.loaderInfo.parameters[pFlashVar];
		return val == null ? pDefault : val;
	}
}