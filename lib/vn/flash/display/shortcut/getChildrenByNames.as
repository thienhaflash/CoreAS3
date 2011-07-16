package vn.flash.display.shortcut 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author thienhaflash (thienhaflash@gmail.com)
	 */
	public function getChildrenByNames(parent: Object, names: *): Array
	{
		var pp	: DisplayObjectContainer = parent as DisplayObjectContainer;
		var ch	: Array =  (names as Array) || [names];
		
		for (var i: int = ch.length - 1; i > -1; i--) {
			ch[i] = pp.getChildByName(ch[i]) || parent[ch[i]];
		}
		return ch;
	}
}