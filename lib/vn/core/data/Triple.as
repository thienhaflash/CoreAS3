package vn.core.data
{
	import vn.core.Dispatcher;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public class Triple extends Dispatcher
	{
		//TODO : consider using int or Number ?
		protected var _first	: int;
		protected var _total	: int;
		protected var _nView	: int;
		
		public function setValues(first: int, total: int, nView: int): Dispatcher {
			_first = first;
			_total = total;
			_nView = nView;
			
			return this;
		}
		
		public function get first():int { return _first; }
		
		public function set first(value:int):void 
		{
			_first = value;
			dispatch('FIRST_CHANGED');
		}
		
		public function get total():int { return _total; }
		
		public function set total(value:int):void 
		{
			_total = value;
			dispatch('TOTAL_CHANGED');
		}
		
		public function get nView():int { return _nView; }
		
		public function set nView(value:int):void 
		{
			_nView = value;
			dispatch('NVIEW_CHANGED');
		}
	}

}