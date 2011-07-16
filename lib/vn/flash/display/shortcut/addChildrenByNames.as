package vn.flash.display.shortcut 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author thienhaflash (thienhaflash@gmail.com)
	 */
	public function addChildrenByNames(parent: Object, names: * ): void {
		var pp	: DisplayObjectContainer = parent as DisplayObjectContainer;
		var c	: DisplayObject;
		var ch	: Array = (names as Array) || [names]; //we'd rather have clean code than best performance one
		
		for (var i: int = ch.length - 1; i > -1; i--) {
			c = parent[ch[i]];
			if (c) pp.addChild(c);
		}
	}
}