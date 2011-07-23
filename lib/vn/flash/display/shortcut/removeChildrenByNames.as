package vn.flash.display.shortcut 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author thienhaflash (thienhaflash@gmail.com)
	 */
	public function removeChildrenByNames(parent: Object, names: *, returnChildren: Boolean = false): Array {
		var pp	: DisplayObjectContainer = parent as DisplayObjectContainer;
		var c	: DisplayObject;
		names = names is Array ? names : [names];
		var arr : Array = returnChildren ? [] : null;
		for (var i: int = names.length-1; i > -1; i--) {
			c = pp.getChildByName(names[i]) || parent[names[i]];
			if (c) returnChildren ? arr.push(pp.removeChild(c)) : pp.removeChild(c);
		}
		return arr;
	}

}