package vn.flash.display.shortcut 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author thienhaflash (thienhaflash@gmail.com)
	 */
	public function getChildrenExceptNames(parent: Object, exceptNames: *): Array
	{
		var pp	: DisplayObjectContainer = parent as DisplayObjectContainer;
		var arr	: Array = (exceptNames as Array) || [exceptNames];
		var c	: DisplayObject;
		var ch	: Array = [];
		
		for (var i: int = pp.numChildren - 1; i > -1; i--) {
			c	= pp.getChildAt(i);
			if (c && arr.indexOf(c.name) == -1) ch.push(c);
		}
		return ch;
	}
}