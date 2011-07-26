package vn.flash.event.shortcut 
{
	import vn.manager.EnterFrame;
	
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function onNextFrame(f: Function, params : Array = null) : void { EnterFrame.onNext(f, params); }
}