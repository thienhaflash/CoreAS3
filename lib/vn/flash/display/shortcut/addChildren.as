package vn.flash.display.shortcut 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function addChildren(parent: Object, children: Array, at: int = -1) : void
	{
		var pp	: DisplayObjectContainer = parent as DisplayObjectContainer;
		for (var i: int = children.length-1; i > -1; i--) {
			at == -1 ? pp.addChild(children[i]) : pp.addChildAt(children[i], at);
		}
	}
}