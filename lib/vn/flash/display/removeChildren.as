package vn.flash.display 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * @param	pParent the display object container whose children will be removed
	 * @param	pIgnore number of children will be pIgnored
	 * @param	pTopDown delete the child from top-down or bottom-up
	 */
	public function removeChildren(pParent : DisplayObject, returnChildren: Boolean = false, fromTop: Boolean = false): Array
	{
		var pp	: DisplayObjectContainer = pParent as DisplayObjectContainer;
		var ch	: Array;
		var n	: int = pp.numChildren;
		
		if (returnChildren) {
			ch = [];
			while (n-- > 0) ch.push(pp.removeChildAt(fromTop ? n : 0));
		} else {
			while (n-- > 0) pp.removeChildAt(fromTop ? n : 0);
		}
		
		return ch;
	}
}