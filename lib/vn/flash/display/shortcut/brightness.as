package vn.flash.display.shortcut 
{
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author ...
	 */
	public function brightness(target : Object, amount: Number = 1): void
	{
		var ct	: ColorTransform = new ColorTransform();
		var val	: int = amount * 255;
		
		ct.redOffset	= val;
		ct.greenOffset	= val;
		ct.blueOffset	= val;
		target.transform.colorTransform = ct;
	}
}