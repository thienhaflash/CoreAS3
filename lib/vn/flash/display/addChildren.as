package vn.flash.display 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function addChildren(parent: DisplayObject, children: Array, at: int = -1) : void
	{
		var pp	: DisplayObjectContainer = pParent as DisplayObjectContainer;
		var n	: int = children.length;
		
		for (var i: int = 0; i < n; i++) {
			at == -1 ? pp.addChild(children[i]) : pp.addChildAt(children[i], at);
		}
	}
}