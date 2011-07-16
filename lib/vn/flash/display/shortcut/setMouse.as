package vn.flash.display.shortcut 
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	/**
	 * @param	pObject the interactive object that will be reset mouse-interaction
	 * @param	pMouseEnabled
	 * @param	pButtonMode 
	 * @param	pMouseChildren
	 */
	public function setMouse(target: Object, mouseEnabled: Boolean = false, buttonMode: Boolean  = false, mouseChildren: Boolean = false): void
	{
		var ido : InteractiveObject = target as InteractiveObject;
		if (ido) ido.mouseEnabled = mouseEnabled;
		var sprt : Sprite = target as Sprite;
		if (sprt) {
			sprt.buttonMode		= buttonMode;
			sprt.mouseChildren	= mouseChildren;
		}
	}
}