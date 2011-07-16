package vn.flash.display.shortcut 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * @param	parent the display object container whose children will be removed
	 * @param	pIgnore number of children will be pIgnored
	 * @param	pTopDown delete the child from top-down or bottom-up
	 */
	public function removeChildren(parent:Object, returnChildren:Boolean = false, fromTop:Boolean = false, ignoreCount:int = 0):Array {
		var pp	: DisplayObjectContainer = parent as DisplayObjectContainer;
		var ch	: Array = returnChildren ? [] : null;
		var n	: int = pp.numChildren;
		var c	: DisplayObject;
		
		while (--n >= 0) {
			c = pp.removeChildAt(fromTop ? n : 0);
			if (returnChildren) ch.push(c);
		}
		//TODO : fix this
		return ch;
	}
}