package vn.flash.display.shortcut 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * @param	parent
	 * @param	pTopDown get from top down or bottom up
	 * @param	pIgnore ignore some child(children)
	 * @return
	 */
	public function getChildren(parent: Object, fromTop : Boolean = false, ignoreCount : int = 0): Array {
		var pp	: DisplayObjectContainer = parent as DisplayObjectContainer;
		var n	: int = pp.numChildren;
		var ch : Array = [];
		for (var i: int = n - ignoreCount-1; i > -1 ; i--) {
			ch.push(fromTop ? pp.getChildAt(n-i-1) : pp.getChildAt(i));
		}
		return ch;
	}
}