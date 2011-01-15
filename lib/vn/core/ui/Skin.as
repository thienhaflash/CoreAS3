package vn.core.ui 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public class Skin 
	{
		
		
		
		public function Skin() {
			_elements = [];
		}
		
	/******************************
	 * 	TARGET DISPLAY OBJECT
	 *****************************/
		
		protected var _targetDO		: DisplayObjectContainer;
	 
		public function get targetDO():DisplayObjectContainer { return _targetDO; }
		
		public function set targetDO(value:DisplayObjectContainer):void 
		{
			var l		: int = _elements.length;
			var i		: int;
			var se		: SkinElement;
			var obj		: Object;
			
			if (_targetDO && l>0) {//remove old skin elements
				for (i = 0; i < l; i++) {
					se = _elements[i];
					obj = _targetDO.getChildByName(se.name);
					if (obj) Interaction.remove(obj, se.behavior, se.action);
					obj = value.getChildByName(se.name);
					if (obj) Interaction.add(obj, se.behavior, se.action);
				}				
			}
			_targetDO = value;
		}
		
	/******************************
	 * 		ELEMENTS
	 *****************************/
		
		protected var _elements		: Array;
		
		public function addElement(name: String, behavior: String, action: Function): Skin {
			_elements.push(new SkinElement(name, behavior, action));
			return this;
		}
		
		public function setElementBehavior(name: String, behavior: String, newBehavior: String): void {
			var l	: int = _elements.length;
			var se	: SkinElement;
			var obj : Object;
			
			for (var i :int = 0 ; i < l; i++) {
				se = _elements[i];
				if (se.name == name && se.behavior == behavior) {
					se.behavior = newBehavior;
					obj = _targetDO.getChildByName(name);
					if (obj) {
						Interaction.remove(obj, behavior, se.action);
						Interaction.add(obj, newBehavior, se.action);
					}
					break;
				}
			}
			
			
		}
		
	/******************************
	 * 		RESIZE TARGET
	 *****************************/
		
		//Consider support for null element size (?) - save information for null elements so we can apply once the new skin is registered
		protected var _width		: int;
		protected var _height 		: int;
		
		public function setSize(w: int, h: int): void {
			//TODO : apply liquid rule ?
		}
		
		public function getElementSize(elementName: String, isHorz: Boolean): int {
			return isHorz ? _targetDO.getChildByName(elementName).width : _targetDO.getChildByName(elementName).height;
		}
		
		public function setElementSize(elementName : String, value : Number, isHorz: Boolean, reference: String = null): DisplayObject {
			var e : DisplayObject = _targetDO.getChildByName(elementName);
			var r : DisplayObject = reference  ? _targetDO.getChildByName(reference) : null;
			r ? (isHorz ? e.width = r.width * value : e.height = r.height * value) : (isHorz ? e.width = value : e.height = value);
			return e;
		}
		
		public function getElementPosition(elementName: String, isHorz: Boolean): int {
			return isHorz ? _targetDO.getChildByName(elementName).x : _targetDO.getChildByName(elementName).y;
		}
		
		public function setElementPosition(elementName: String, value: int, isHorz: Boolean, reference: String = null): void {
			var e : DisplayObject = _targetDO.getChildByName(elementName);
			var r : DisplayObject = reference  ? _targetDO.getChildByName(reference) : null;
			r ? (isHorz ? e.x = r.x + value : e.y = r.y + value) : (isHorz ? e.x = value : e.y = value);
			return e;
		}
	}
}

class SkinElement {
	public var name			: String;
	public var behavior		: String;
	public var action		: Function;
}