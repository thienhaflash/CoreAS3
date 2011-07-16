package vn.flash.display.shortcut 
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	/**
	 * ...
	 * @author thienhaflash (thienhaflash@gmail.com)
	 */
	public function grayscale(target: Object, amount: Number = 1): void
	{
		if (amount == 0) {
			(target as DisplayObject).filters = []; return;
		}
		var r : Number = 0.3086;
		var g : Number = 0.6094;
		var b : Number = 0.0820;
		var a : Number = amount;
		var d : Number = 1 - amount;
		
		(target as DisplayObject).filters = [
			new ColorMatrixFilter([	a * r + d	, a * g		, a * b		, 0, 0,
									a * r		, a * g + d	, a * b		, 0, 0,
									a * r		, a * g		, a * b + d	, 0, 0,
									0, 0, 0, 1, 0])
		]
	}
}