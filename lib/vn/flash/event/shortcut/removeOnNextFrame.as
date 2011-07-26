package vn.flash.event.shortcut 
{
	import vn.manager.EnterFrame;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function removeOnNextFrame(f: Function): void { EnterFrame.remove_onNext(f); }
}