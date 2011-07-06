package vn.flash.display 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * @param	pParent
	 * @param	pTopDown get from top down or bottom up
	 * @param	pIgnore ignore some child(children)
	 * @return
	 */
	public function getChildren(pParent: DisplayObject, fromTop : Boolean = false, ignoreCount : int = 0): Array {
		var pp	: DisplayObjectContainer = pParent as DisplayObjectContainer;
		var n	: int = pp.numChildren;
		var arr : Array = [];
		for (var i: int = 0; i < n - ignoreCount; i++) {
			arr.push(fromTop ? pp.getChildAt(n-i-1) : pp.getChildAt(i));
		}
		return arr;
	}
}