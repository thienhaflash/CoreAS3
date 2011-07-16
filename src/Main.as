package  
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import vn.flash.display._KDisplayImpl;
	import vn.flash.display.KDisplay;
	import vn.flash.display.shortcut.addChildren;
	import vn.flash.display.shortcut.brightness;
	import vn.flash.display.shortcut.getChildren;
	import vn.flash.display.shortcut.getChildrenByNames;
	import vn.flash.display.shortcut.getChildrenExceptNames;
	import vn.flash.display.shortcut.grayscale;
	import vn.flash.display.shortcut.removeChildren;
	import vn.flash.display.shortcut.tint;
	
	/**
	 * ...
	 * @author thienhaflash
	 */
	public class Main extends MovieClip
	{
		protected var mc : mcx_lnk = new mcx_lnk();
		
		public function Main()
		{
			mc.x = 100;
			addChild(mc);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveMouse);
			
			//removeChildren(mc);
			//addChildren(this, getChildren(mc, true, 1));
			//trace(getChildrenByNames(mc, ["mc1","mc2"])[1].name);
			//trace(getChildrenExceptNames(mc, ["mc1","mc4", "mc3"])[0].name);
		}
		
		private function onMoveMouse(e:MouseEvent):void 
		{
			var pctX : Number = stage.mouseX / stage.stageWidth;
			//grayscale(mc, pctX);
			//tint(mc, 0xffff00, pctX);
			brightness(mc, pctX);
		}
		
	}

}