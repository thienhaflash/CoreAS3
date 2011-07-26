package  
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import vn.flash.display._KDisplayImpl;
	import vn.flash.display.KDisplay;
	import vn.flash.display.shortcut.addChildren;
	import vn.flash.display.shortcut.bevel;
	import vn.flash.display.shortcut.blur;
	import vn.flash.display.shortcut.brightness;
	import vn.flash.display.shortcut.dropshadow;
	import vn.flash.display.shortcut.format;
	import vn.flash.display.shortcut.getChildren;
	import vn.flash.display.shortcut.getChildrenByNames;
	import vn.flash.display.shortcut.getChildrenExceptNames;
	import vn.flash.display.shortcut.glow;
	import vn.flash.display.shortcut.grayscale;
	import vn.flash.display.shortcut.removeChildren;
	import vn.flash.display.shortcut.removeChildrenByNames;
	import vn.flash.display.shortcut.removeChildrenExceptNames;
	import vn.flash.display.shortcut.rotateAround;
	import vn.flash.display.shortcut.scaleAround;
	import vn.flash.display.shortcut.setMouse;
	import vn.flash.display.shortcut.tint;
	import vn.flash.event.shortcut.addLsn;
	import vn.flash.event.shortcut.remLsn;
	//import vn.manager.Aim;
	
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
			mc.y = 100;
			
			addChild(mc);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveMouse);
			
			//addChildren(this, getChildren(mc, true, 1));
			//trace(getChildrenByNames(mc, ["mc1","mc2"])[1].name);
			//trace(getChildrenExceptNames(mc, ["mc1", "mc3"]));
			
			//removeChildren(mc)
			//removeChildrenByNames(mc, ['mc1', 'mc2']);
			//removeChildrenExceptNames(mc, ['mc1', 'mc2'], true);
			
			//addChild(format(new TextField(), { useDefaults: true, border: true, text: 'hihihehe', x: 100, bold : true, size: 30 }, true));
			
			m = mc.transform.matrix;
			
			addLsn(stage, MouseEvent.MOUSE_DOWN, trace, ['MouseDown']);
			addLsn(stage, MouseEvent.MOUSE_UP, trace, ['MouseUp']);
			addLsn(stage, MouseEvent.MOUSE_MOVE, trace, ['MouseMove']);
			addLsn(stage, MouseEvent.MOUSE_MOVE, function (s: String): void { trace(s) }, ['MouseMove 2']);
			remLsn(stage, MouseEvent.MOUSE_MOVE);
			//remLsn(stage);
			//remLsn(stage, null, trace); //remove all trace listeners, only MouseMove 2 left !
		}
		
		protected var m : Matrix;
		
		private function onMoveMouse(e:MouseEvent):void 
		{
			var pctX : Number = stage.mouseX / stage.stageWidth;
			
			//grayscale(mc, pctX);
			//tint(mc, 0xffff00, pctX);
			//brightness(mc, pctX);
			
			//rotateAround(mc, 100, 100, pctX * 360, m);
			//scaleAround(mc, 120, 120, pctX*10, pctX*10, m);
			
			//glow(mc, 0x00ff00, 1, 10 * pctX, 10 * pctX);
			//blur(mc, 10 * pctX, 10 * pctX);
			//bevel(mc, 10 * pctX);
			//dropshadow(mc, 10 * pctX);
			
		//	Aim.getProp(mc).x = stage.mouseX;
			//Aim.getProp(mc).y = stage.mouseY;
		}
		
	}

}