package vn.manager 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import vn.manager.shortcut.onEachFrame;
	/**
	 * ...
	 * @author kudoshinichi
	 */
	public class Aim
	{
		protected static var dict : Dictionary;
		protected var target : Object;
		
		public var dirty	: Boolean;
		public var props	: Object;
		public var v		: Number;
		public var once		: Boolean;//auto remove when it's clean
		
		public function Aim(tar: Object, p: Object, o: Boolean = true) 
		{
			if (!dict) {
				dict = new Dictionary(true);
				onEachFrame(_update);
			}
			
			v = 1 / 10;
			
			var aim : Aim = dict[tar];
			
			if (!aim) {//not existed
				dict[tar] = this;
				dirty = true;
				
				target = tar;
				props = p;
				once = o;
				
			} else {//already exist
				aim.dirty = true;
				aim.props = p;
				aim.once = o;
			}
		}
		
		public static function getProp(tar: Object, v: Number = -1): Object {
			var aim: Aim;
			var obj : Object;
			
			if (!dict || !dict[tar]) {
				obj = { };
				aim = new Aim(tar, obj);
			} else {
				aim = dict[tar];
				aim.dirty = true;
				obj = aim.props;
			}
			
			if (v > 0) {
				aim.v = v;
			}
			
			return obj;
		}
		
		private static function _update():void 
		{
			var s	: String;
			var aim : Aim;
			var dv	: Number;
			var isDead : Boolean;
			
			for (var tar : * in dict) {
				aim = dict[tar];
				if (aim.dirty) {
					isDead = true;
					for (s in aim.props) {
						dv = (aim.props[s] - aim.target[s]) * aim.v;
						
						if (dv != 0) {
							isDead = false; 
							aim.target[s] += dv;;
						}
					}
					if (isDead) {
						aim.target[s] = aim.props[s];//force render last value
						(aim.once) ? delete dict[tar] : aim.dirty = false;
					}
				}
			}
		}
	}

}