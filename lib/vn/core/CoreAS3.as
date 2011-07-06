package vn.core 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import vn.flash.kCopyProps;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public class CoreAS3 
	{
		
		public static function initialize(stage: Stage, setupDefaults: Boolean = true): void {
			if (!stage) return;
			
			flashroot	= stage.root;
			flashstage	= stage;
			
			if (setupDefaults) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
		}
	}

}