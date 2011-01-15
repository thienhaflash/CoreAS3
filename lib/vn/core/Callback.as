package vn.core
{
	import flash.utils.Dictionary;
	
	public class Callback
	{
		protected var dict			: Dictionary = new Dictionary();
		
		final public function addLsn(f: Function, params: Array = null): void {
			dict[f] = params;
		}
		
		final public function remLsn(f: Function): void {
			if (dict[f]) delete dict[f];//a bit slower than nullize but we need to sacrifice for filesize
		}
		
		final public function remAllLsn(): void {
			dict = new Dictionary();
		}
		
		final public function dispatch(): void {
			if (_skipEvent) return;
			
			for (var f: * in dict) {
				f.apply(null, dict[f]);
			}
		}
		
		protected var _skipEvent	: Boolean;
		
		final public function get skipEvent():Boolean { return _skipEvent; }
		
		final public function set skipEvent(value:Boolean):void 
		{
			_skipEvent = value;
		}
		
	}

}