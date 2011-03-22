package vn.core.optimize 
{
	import flash.utils.Dictionary;
	/**
	 * Object pooling for better object management (reuse instead of contantly create / dispose)
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	22 March 2011
	 * 
	 * @features
	 * 		Support cloning from constructor or newFunction
	 * 		Support hookings fCreate / fDestroy to init / dispose items correctly
	 * 		Support resize function to use with buffer
	 * 
	 */ 
	public class Pool 
	{
		protected var _rate		: int; //increasing rate
		protected var _size 	: int; //size of the pool : number of items currently in the pool
		protected var _list		: Array; //use DA part won't slow down Array
		
		protected var _cls		: Class;//must not allow parameters
		
		public var fCreate		: Function;
		public var fDestroy		: Function;
		
		public function Pool(ClassOrNewFunc : *, initPool: Boolean = true, rate: int = 20, destroyFunc: Function = null) {
			_list = [];
			_rate = rate;
			
			if (ClassOrNewFunc == null) trace('Pool error ! Class or NewFunc is null');
			
			if (ClassOrNewFunc is Class) {
				_cls = ClassOrNewFunc as Class;
				fCreate = newClass;
			} else {
				fCreate = ClassOrNewFunc as Function;
			}
			fDestroy = destroyFunc;
			
			if (initPool) increase();
		}
		
		protected function newClass(): Object {
			return new _cls();
		}
		
		protected function increase(): void {
			//TODO : consider threading - limit by nItems per frame (?)
			for (var i: int = 0; i < _rate; i++) {
				_list.push(fCreate());
			}
			_size += _rate;
			//trace(_list.length);
		}
		
		public function returnToPool(obj: Object): void {
			//TODO : consider max --> destroy :: 
			if (fDestroy != null) fDestroy(obj);//destroy object if there is a destructor
			
			_list.push(obj);
			_size ++;
		}
		
		public function getFromPool(): Object {
			//TODO : consider support minimun size for calling increase
			if (_size == 0) increase();
			_size--;
			return _list.pop();
		}
		
		public function resize(arr: Array, length : int): Array {
			var delta : int = arr.length - length;
			if (length < 0 || delta == 0) return arr; //do nothing
			
			var absDelta	: int = Math.abs(delta);
			for (var i: int = 0; i < absDelta; i++) {
				delta > 0 ? returnToPool(arr.pop()) : arr.push(getFromPool());
			}
			
			return arr;
		}
		
	/*******************
	 * 		STATIC
	 *******************/
		
		private static var _instances	: Dictionary;
		
		public static function get(ClassOrNewFunc : *, initPool: Boolean = true, rate: int = 20, destroyFunc: Function = null): Pool {
			if (!_instances) _instances = new Dictionary();
			var pool : Pool = _instances[ClassOrNewFunc];
			if (!pool) {
				pool = new Pool(ClassOrNewFunc, initPool, rate, destroyFunc);
				_instances[ClassOrNewFunc] = pool;
			}
			return pool;
		}
		
	}
}