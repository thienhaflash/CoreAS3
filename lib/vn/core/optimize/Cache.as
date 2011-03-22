package vn.core.optimize 
{
	import flash.utils.Dictionary;
	/**
	 * Advanced cache use for preserving external assets or storing heavy calculated results for better performance
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	22 March 2011
	 * 
	 * @features
	 * 		Support weak and fix sized strong reference to cache for better caching behavior
	 * 
	 */ 
	public class Cache 
	{
		protected var _cache	: Dictionary;
		
		protected var _fixed	: Array;//hard reference to prevent gc
		protected var _fsize	: int;//length of fixed
		protected var _index	: int;//start index in fixed size
		
		/* for tracking effectiveness */
		protected var _plus		: int;
		protected var _total	: int;
		
		public function Cache(fixedSize: int = 0) {
			_fsize = fixedSize;
			_fixed = [];
			_cache = new Dictionary(true);
		}
		
		public function clearAll():void {//clear cache
			_fixed = [];
			_cache = new Dictionary(true);
		}
		
		public function keep(item: Object): void {//keep an item in fixed Array
			_fixed[_index]	= item;
			_index = (++_index) % _fsize;
		}
		
		public function register(item: *, id: String, useKeep: Boolean = true): void {
			_cache[item]		= id;
			if (useKeep) keep(item);
		}
		
		public function get(id: String): * {
			var ro : *;
			
			for (var o: * in _cache) {
				if (_cache[o] == id) {
					_plus ++;
					ro = o;
					break;
				}
			}
			_total++;
			//trace(ro, effective);
			return ro;
		}
		
		public function get effective(): Number {
			return _total == 0 ? 0 : _plus / _total;
		}
		
	}

}