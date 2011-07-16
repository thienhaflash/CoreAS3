package vn.flash.display.shortcut 
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function tint(target : Object, color: int, amount: Number = 1): void
	{
		var ct	: ColorTransform = new ColorTransform();
		ct.color			= color;
		ct.redOffset		= amount * ct.redOffset;
		ct.greenOffset		= amount * ct.greenOffset;
		ct.blueOffset		= amount * ct.blueOffset;
		
		ct.redMultiplier	= 1 - amount;
		ct.greenMultiplier	= 1 - amount;
		ct.blueMultiplier	= 1 - amount;
		
		(target as DisplayObject).transform.colorTransform = ct;
	}
}