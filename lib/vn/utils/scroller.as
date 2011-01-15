package vn.utils 
{
	import flash.display.DisplayObject;
	import vn.ui.Scroller;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function scroller(pskin: DisplayObject) : Scroller
	{
		return Scroller.get(pskin);
	}
}