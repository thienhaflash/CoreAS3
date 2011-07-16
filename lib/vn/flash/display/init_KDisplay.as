package vn.flash.display 
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function init_KDisplay(stage: Stage, setupDefaults: Boolean = true) : _IKDisplay
	{
		if (!KDisplay) {
			flashroot	= stage.root;
			flashstage	= stage;
			KDisplay	= new _KDisplayImpl();
			
			if (setupDefaults) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}			
		}
		return KDisplay;
	}
}