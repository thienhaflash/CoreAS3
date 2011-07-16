package vn.flash.display.shortcut 
{
	import flash.filters.DropShadowFilter;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function dropShadow(target:Object, distance:Number = 4.0, angle:Number = 45, color:uint = 0, alpha:Number = 1.0, blurX:Number = 4.0, blurY:Number = 4.0, strength:Number = 1.0, quality:int = 1, inner:Boolean = false, knockout:Boolean = false, hideObject:Boolean = false):void {
		target.filters = [new DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject)];
	}
}