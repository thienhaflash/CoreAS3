package vn.flash.display 
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function tint(target : DisplayObject, color: int, amount: Number = 1) 
	{
		var ct	: ColorTransform = new ColorTransform();
		ct.redOffset = 0;
		ct.greenOffset = 0;
		ct.blueOffset = 0;
		
		ct.color			= _color;
		
		ct.redOffset = _amount*ct.redOffset;
		ct.greenOffset = _amount*ct.greenOffset;
		ct.blueOffset = _amount*ct.blueOffset;
		
		ct.redMultiplier	= 1 - _amount;
		ct.greenMultiplier = 1 - _amount;
		ct.blueMultiplier	= 1 - _amount;
		
		target.transform.colorTransform = ct;
	}
}