package vn.core.optimize
{
	import flash.utils.Dictionary;
	import vn.core.data.ArrayResizer;
	/**
	 * Buffering used mainly for DisplayObject to boost performance and decrease memory required
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	22 March 2011
	 * 
	 * @features
	 * 		Smart update minimum number items that changes content
	 * 		Dynamic resizing at anytime & allow force refresh
	 * 
	 */ 
	public class Buffer
	{
		protected var _items 	: Array; //of DisplayObject
		protected var _nItems	: int; //_items.length
		
		protected var _first	: int;
		protected var _last		: int; // = Math.min(_first+_nItems-1, _total-1);
		
		protected var _total	: int;		
		protected var _loop		: Boolean = true;
		
		protected var _resizer	: ArrayResizer;
		protected var _update	: Function;
		
		protected var _mapIdx	: Dictionary;
		
		public function Buffer() 
		{
			_mapIdx = new Dictionary();
		}
		
		private function _init(items: Array, pN: int , update: Function, loop: Boolean): void {
			_update	= update;
			_loop	= loop;
			_items 	= items;
			
			nItems = pN;//create now (?)
		}
		
		public function get init(): ArrayResizer {
			var hasResizer : Boolean = _resizer != null;
			if (!hasResizer) _resizer = new ArrayResizer(this, _init);
			return hasResizer ? null : _resizer;//valid only first time
		}		
		
		/**
		 * call when the target is removed from stage, collect to be used by others
		 */
		public function freeze(): void { //remove all items to the pool
			_resizer.resize(_items, 0);
		}
		
		/**
		 * call when the target is added to stage, retrieve from the pool
		 */
		public function unFreeze(): void { //reset state
			_resizer.resize(_items, Math.min(_total, _nItems));
			updateContent( -1, _nItems);
		}
		
		public function reset(ptotal: int, doUpdate: Boolean): Buffer {
			_total = ptotal;
			_resizer.resize(_items, Math.min(_total, _nItems));
			for (var i: int = 0; i < _nItems; i++) {
				_mapIdx[_items[(_first + i) % _nItems]] = first + i;
			}
			_last = Math.min(_nItems - 1, _total - 1);
			
			if (doUpdate) {
				_first = 0;
				updateContent( -1, _nItems);
			}
			return this;
		}
		
		public function updateContent(from: int = -1, nUpdate : int = 1): void {
			from	= from < _first ? _first : from > _last ? _last : from;
			var to : int = Math.min(from + nUpdate, _last + 1);		
			//TODO : what happens if from < 0 ?
			var offset	: int = from - int(from / _nItems) * _nItems;
			var itm		: Object;
			
			for (var i: int = from; i < to; i++) {
				itm = _items[(offset + i - from) % _nItems];
				_mapIdx[itm] = i;
				_update(itm, i);
			}
		}
		
		public function getItemId(itm: Object): int {
			return _mapIdx[itm];
		}
		
		public function get first():int { return _first; }
		
		public function set first(value:int):void 
		{
			if (!_loop) value = value<0 ? 0 : value>_total-_nItems ? Math.max(0, _total-_nItems) : value;
			
			if (_first != value) {
				var from	: int = value > _first ? _last +1 : value;
				var nMove	: int = Math.abs(value - _first);
				
				_first = value;	
				_last = Math.min(_first + _nItems - 1, _total - 1);
				
				if (nMove >= _nItems) {
					updateContent(-1, _nItems);
				} else {
					updateContent(from, nMove);
				}
			}
		}
		
		public function get items():Array { return _items; }
		
		public function get nItems():int { return _nItems; }
		
		public function set nItems(value:int):void 
		{
			_resizer.resize(_items, Math.min(_total, value));
			_nItems = value;
			_last = Math.min(_first + _nItems - 1, _total - 1);
			
			//keep indexing clean
			//for (var i: int = 0; i < _nItems; i++) {
				//_mapIdx[_items[(_first + i) % _nItems]] = first + i;
			//}
			
			updateContent( -1, _nItems);
		}
		
		public function get last():int { return _last; }
		
		public function get mapIdx():Dictionary { return _mapIdx; }
		
		public function get total():int { return _total; }
	}
}