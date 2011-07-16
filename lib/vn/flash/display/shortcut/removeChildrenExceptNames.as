package vn.flash.display.shortcut 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author thienhaflash (thienhaflash@gmail.com)
	 */
	public function removeChildrenExceptNames(parent: Object, exceptNames: * , returnRemovedDO : Boolean = false): Array {
		var pp	: DisplayObjectContainer = parent as DisplayObjectContainer;
		var arr	: Array = (exceptNames as Array) || [exceptNames];
		var c	: DisplayObject;
		var ch	: Array = returnRemovedDO ? [] : null;
		
		for (var i: int = arr.length - 1; i > -1; i--) {
			c	= pp.getChildAt(i);
			if (c && arr.indexOf(c.name) == -1) {
				pp.removeChild(c);
				if (returnRemovedDO) ch.push(c);
			}
		}
		return ch;
	}
}