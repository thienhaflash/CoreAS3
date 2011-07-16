package vn.flash.display.shortcut 
{
	import flash.filters.BlurFilter;
	/**
	 * ...
	 * @author ...
	 */
	public function blur(target:Object, blurX:Number = 4.0, blurY:Number = 4.0, quality:int = 1):void {
		target.filters = (blurX == 0 && blurY ==0) ? [] : [new BlurFilter(blurX, blurY, quality)];
	}
}