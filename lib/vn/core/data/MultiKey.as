package vn.core.data 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public class MultiKey 
	{
		private var keys 		: Dictionary;
		private var keyCnt		: int;
		private var key2Value	: Dictionary; /* Object should also be fine here */
		
		private function combineKeys(autoNew: Boolean, keyList: Array): Array {
			if (!keys) return null;
			var arr	 : Array = [];
			var ckey : * ;
			var l	 : int = keyList.length;
			
			for (var i: int = 0; i <l; i++) {//keep the order !
				ckey = keys[keyList[i]];
				if (!ckey) { //skip zero !
					if (autoNew) {
						keys[keyList[i]]	= ++keyCnt;
						keys[keyCnt]		= keyList[i];
						ckey				= keyCnt;
					} else {
						return null;
					}
				}
				arr.push(ckey);
			}
			//arr.sort(Array.NUMERIC); /* so the key is unique combination */
			return arr;
		}
		
		private function isValidKey(keys : Array, combine: Array): Boolean {
			var l: int = combine.length;
			for (var i: int = 0; i < l; i++) {
				if (keys.indexOf(''+combine[i]) == -1) {//can not found some key
					return false;
				}
			}
			return true;
		}
		
		public function break2Key(s: String): Array {
			var arr : Array = s.split('*');
			for (var i: int = arr.length - 1; i > -1; i--) {
				arr[i] = keys[arr[i]];
			}
			return arr;
		}
		
		public function removeValue(...keyList): * {
			var s 		: String = combineKeys(false, keyList).join('*');
			var value	: * ;
			if (s) {
				value = key2Value[s];
				delete key2Value[s];
			}
			return value;
		}
		
		public function filterValues(keyList: Array, returnValues: Boolean = true): Array {
			var combined	: Array = combineKeys(false, keyList);
			var result		: Array = [];
			for (var s : String in key2Value) {
				if (isValidKey(s.split('*'), combined)) {
					result.push(returnValues ? key2Value[s] : s);
				}
			}
			return result;
		}
		
		public function removeValues(keyList: Array, returnValues: Boolean = true): Object {
			var combined	: Array = combineKeys(false, keyList);
			var result		: Object = {};
			for (var s : String in key2Value) {
				if (isValidKey(s.split('*'), combined)) {
					result[s] = key2Value[s];
					delete key2Value[s];
				}
			}
			return result;
		}
		
		public function getValue(...keyList): * {
			var combined	: Array = combineKeys(false, keyList);
			return combined ? key2Value[combined.join('*')] : null;
		}
		
		public function setValue(value: *, ...keyList): void {
			if (!keys) {
				keys = new Dictionary();
				key2Value = new Dictionary();
			}
			key2Value[combineKeys(true, keyList).join('*')] = value;
		}
	}
}