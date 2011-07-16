package vn.flash.event.shortcut 
{
	import vn.flash.event.EnterFrame;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function removeOnNextFrame(f: Function): void { EnterFrame.remove_onNext(f); }
}