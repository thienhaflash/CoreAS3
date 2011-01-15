package vn.ui
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import vn.core.data.Triple;
	import vn.core.Dispatcher;
	import vn.core.mouse.Drag;
	import vn.core.ui.Interaction;
	import vn.core.ui.Skin;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public class Scroller extends Dispatcher
	{
		public function Scroller() 
		{
			//never put anything on the constructor, not only it's easier to maintain, it's also easier to clone
			_skin = new Skin()
						.addElement(TRACK_NAME, Interaction.MOUSE_DOWN_UP, onTrack)
						.addElement(HAND_NAME, Interaction.DRAG_DROP_THROW, onHand)
						.addElement(PREV_NAME, Interaction.CLICK, onNext)
						.addElement(NEXT_NAME, Interaction.CLICK, onPrev);
		}
		
		private function onTrack():void 
		{
			data.first += data.nView;
		}
		
		private function onHand(d: Drag):void 
		{
			//get drag data / phase here
			if (d.update == 0 ) {//first time update : START DRAG
				d.data = { 	first		: _data.first
							, mouseX	: _skin.targetDO.mouseX
							, ratio 	: (_skin.getElementSize(TRACK_NAME, true) - _skin.getElementSize(HAND_NAME, true))/(_data.total-_data.nView)
						};
			}
			
			data.first = (_skin.targetDO.mouseX - d.data.mouseX) * d.ratio + ;
		}
		
		private function onNext():void 
		{
			position += scrollDelta;
		}
		
		private function onPrev():void 
		{
			
		}
		
	/**************************
	 * 		SKIN
	 *************************/	
		
		protected static const TRACK_NAME	: String = 'scr_track';
		protected static const HAND_NAME	: String = 'scr_hand';
		protected static const PREV_NAME	: String = 'scr_next';
		protected static const NEXT_NAME	: String = 'scr_prev';
		
		protected var _skin : Skin;
		public function get skin():Skin { return _skin; }
		
	/**************************
	 * 		ADAPTER
	 *************************/
		
		public function get relation():Number { return _data.nView/_data.total; }
		
		public function get position():Number { return _data.first / (_data.total - _data.nView); };
		
		public function set position(value:Number):void 
		{
			_data.first = int(value * (_data.total - _data.nView));//may not be very accurate
		}
		
	/**************************
	 * 		CONFIGURATION
	 *************************/
		
		public var scrollDelta	: int; //scroll amount
		
		public function init(pskin: DisplayObject, pdata: Triple = null): void {
			//analyse skin here
		}
		
	/**************************
	 * 		DATA
	 *************************/	
		
		protected var _data		: Triple;
		
		public function inject(data: Triple): void {
			//TODO : remove old _data
			_data = data;
			_data.addLsn('FIRST_CHANGED', onFirstChanged);
			_data.addLsn('TOTAL_CHANGED', onTotalChanged);
			_data.addLsn('NVIEW_CHANGED', onNViewChanged);
		}
		
		private function onFirstChanged():void 
		{
			_updatePosition();
			dispatch('POSITION');
		}
		
		
		private function onTotalChanged():void 
		{
			_updateRelation();
			dispatch('RELATION');
		}
		
		private function onNViewChanged():void 
		{
			_updateRelation();
			dispatch('RELATION');
		}
		
		private function _updatePosition():void 
		{
			//set hand into the correct position based on _position
			_skin.setElementPosition(HAND_NAME, position, true , _skin.getElementPosition(TRACK_NAME));
		}
		
		private function _updateRelation():void 
		{
			_skin.setElementSize(HAND_NAME, relation, true , _skin.getElementPosition(TRACK_NAME));
		}
		
		public function get data():Triple { return _data; }
		
	/**************************
	 * 		STATICS
	 *************************/	
		
		public static var instances : Dictionary = new Dictionary(true);
		
		public static function get(skin: MovieClip, autoNew: Boolean = true):Scroller {
			var scr : Scroller = instances[skin];
			if (!scr && autoNew) scr = new Scroller().init(skin);
			return scr;
		}
		
	}

}