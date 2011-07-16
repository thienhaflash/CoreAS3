package vn.flash.display.shortcut 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function remove(target : Object): DisplayObject 
	{
		if (target && target.parent) target.parent.removeChild(target);
		return target as DisplayObject;
	}
}