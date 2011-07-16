package vn.flash.event.shortcut 
{
	import vn.flash.event.EnterFrame;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function removeOnEachFrame(f: Function): void { EnterFrame.remove_onEach(f); }
}