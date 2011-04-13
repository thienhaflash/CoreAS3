package test 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import vn.core.app.XMLApp;
	import vn.core.draw.Draw;
	import vn.core.optimize.Buffer;
	/**
	 * ...
	 * @author 
	 */
	public class XMLAppTest extends XMLApp
	{
		private var tx: int;
		private var ty: int;
		public function XMLAppTest() 
		{
			var a : Buffer;
			//appConfigURL = 'assets/config.xml';
		}
		
		protected var d : Draw;
		
		override public function initApp():void 
		{
			//trace('initApp :: ', assets.jpg, assets.txt, assets.xml);
			d = new Draw();
			d.useGraphics(this.graphics);
			addEventListener(Event.ENTER_FRAME, updateDraw);
		}
		
		private function updateDraw(e:Event):void 
		{
			tx += (mouseX - tx) / 2;
			ty += (mouseY - ty) / 2;
			
			d.clear();
			d.lineStyle(1, 1);
			//d.drawDashLineTo(tx, ty, 5, 5);
			//d.lineTo(200, 200);
			//d.drawArc(stage.stageWidth / 2, stage.stageHeight / 2, 200, 180, 720 * stage.mouseX / stage.stageWidth);
			//d.drawArc(stage.stageWidth / 2, stage.stageHeight / 2, 100, 0, 360 * stage.mouseX / stage.stageWidth);
			//d.lineTo(stage.stageWidth / 2, stage.stageHeight / 2);
			d.drawArc(stage.stageWidth / 2, stage.stageHeight / 2, 200, 180, 360 * stage.mouseX / stage.stageWidth);
			d.lineTo(stage.stageWidth / 2, stage.stageHeight / 2);
		}
		
	}

}