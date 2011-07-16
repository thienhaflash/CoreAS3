package vn.flash.display.shortcut 
{
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function glow(target:Object, color:uint = 0xFF0000, alpha:Number = 1.0, blurX:Number = 6.0, blurY:Number = 6.0, strength:Number = 2, quality:int = 1, inner:Boolean = false, knockout:Boolean = false):void {
		target.filters = [new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout)];
	}

}