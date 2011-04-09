package vn.core.data 
{
	/**
	 * ...
	 * @author 
	 */
	import vn.core.optimize.Buffer;

	public class ArrayResizer {
		
		private var buff		: Buffer;
		private var buff_init	: Function;
		
		public function ArrayResizer(buffer: Buffer, init: Function) {
			buff = buffer;
			buff_init = init;
		}
		
	/********************
	 * private
	 *******************/	
		
		private var fResize 	: Function;
		private var clean		: Boolean;
		//TODO : Clean array at fixed interval (?)
		
		public function resize(arr: Array, l: int, forceClean :Boolean = false): void {
			clean = forceClean;
			if (fResize != null) fResize(arr, l); //just ignore for other cases (fixed array)
		}
		
		private var _sampleCls : Class;
		private function resizeBySample(arr: Array, l: int): void {
			var delta : int = l - arr.length;
			
			while (delta-- > 0) arr.push(new _sampleCls());
			while (clean && delta++ < 0) arr.pop();//defer pop(); for better performance
		}
		
		private var _newFunc : Function;
		private function resizeByNewFunc(arr: Array, l: int): void {
			var delta : int = l - arr.length;
			while (delta-- > 0) arr.push(_newFunc());
			while (clean && delta++ < 0) arr.pop();//defer pop(); for better performance
		}
		
	/********************
	 * INITIALIZE
	 *******************/
		
		public function bySample(sampleOrClass : *, nItems: int, update: Function, loop: Boolean = false): Buffer {
			fResize = resizeBySample;
			_sampleCls = sampleOrClass is Class ? sampleOrClass as Class : sampleOrClass.constructor;
			buff_init([], nItems, update, loop);
			return buff;
		}
		
		public function byNewFunc(newFunc: Function, nItems: int, update: Function, loop: Boolean = false):Buffer {
			fResize = resizeByNewFunc;
			_newFunc = newFunc;
			buff_init([], nItems, update, loop);
			return buff;
		}
		
		public function byResizeFunc(resizeFunc : Function, nItems: int, update: Function, loop: Boolean = false): Buffer {//use with object pool
			fResize = resizeFunc;
			buff_init([], nItems, update, loop);
			return buff;
		}
		
		public function byExisted(items: Array, update: Function, loop: Boolean = false): Buffer {
			fResize = null;
			buff_init(items, items.length, update, loop);
			return buff;
		}
	}

}