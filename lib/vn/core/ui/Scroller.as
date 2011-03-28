package vn.core.ui 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import vn.core.flash.Drag;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public class Scroller
	{
		public var target		: MovieClip;
		
		public var track		: DisplayObject;
		public var hand			: DisplayObject;
		
		protected var _relation	: Number;
		protected var _position	: Number;
		protected var slideL	: Number;
		
		protected var update	: Function;
		
		public function Scroller(ptarget: MovieClip, pupdate: Function, prelation: Number = 0.25, pposition: Number = 0) 
		{
			target = ptarget;
			track = target.mcTrack;
			hand = target.mcHand;
			
			update = pupdate;
			
			Drag.register(track).setCallback(onDragTrack);
			Drag.register(hand).setCallback(onDragHand);
			target.parent.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			tp = 0;
			relation = prelation;
			position = pposition;
		}
		
		protected var tp : Number;
		
		private function updatePosition(e:Event):void 
		{	
			var delta : Number = (tp - _position) / 5;
			
			if (_position + delta == _position ) {//Don't change anymore
				position = tp;
				target.removeEventListener(Event.ENTER_FRAME, updatePosition);
			} else {
				position = _position + delta;
			}
		}
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			var tVal : Number = tp + (e.delta < 0 ? _relation : -_relation);
			tp = tVal<0 ? 0 : tVal>1 ? 1 : tVal;			
			target.addEventListener(Event.ENTER_FRAME, updatePosition);
		}
		
		private function onDragTrack():void
		{
			updateDrag(Drag.getDrag(track), target.mouseY / track.height);
		}
		
		private function updateDrag(d: Drag, val: Number):void
		{
			if (d.update == 0) d.data = { value: val, mouseY: target.mouseY };
			
			var tVal : Number = (target.mouseY - d.data.mouseY) / slideL + d.data.value;
			tp = tVal<0 ? 0 : tVal>1 ? 1 : tVal;
			if (tp != _position) target.addEventListener(Event.ENTER_FRAME, updatePosition);
		}
		
		private function onDragHand():void
		{
			updateDrag(Drag.getDrag(hand), _position);
		}
		
		public function get relation():Number { return _relation; }
		
		public function set relation(value:Number):void 
		{
			_relation = value;
			target.visible = !(_relation<=0 || _relation>1);
			
			if (target.visible) {
				hand.height = Math.max(20, track.height * _relation);
				slideL = track.height - hand.height;
				position = 0;
			}
		}
		
		public function get position():Number { return _position; }
		
		public function set position(value:Number):void 
		{
			_position = value<0 ? 0 : value>1 ? 1 : value;			
			hand.y = slideL * _position;
			update(_position);
		}
		
	}

}