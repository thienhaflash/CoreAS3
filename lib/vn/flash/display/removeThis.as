package vn.flash.display 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function removeThis(pDO : DisplayObject): DisplayObject 
	{
		if (pDO && pDO.parent) pDO.parent.removeChild(pDO);
		return pDO;
	}
}