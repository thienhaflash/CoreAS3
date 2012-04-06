package vn.utils {
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public class KButton {
		public static var logger	: Function		= log;
		private static var _map		: Dictionary	= new Dictionary(true);
		
		private static function log(funcName: String, message: String): void {
			trace('[ButtonHelper.' + funcName + '() ' + message);
		}
		
		private static function check(pdo: Object): int {
			//1 : non-interactive object
			//2 : existed in _map
			//3 : not yet existed in _map
			return pdo is InteractiveObject ? _map[pdo] ? 2 : 3 : 1;
		}
		
		private static function _add(pdo: InteractiveObject, onOver: Function, onOut: Function, onClick:Function, params: Array = null, data: Object = null): void {
			//buttonMode (default = true)
			if (pdo.hasOwnProperty('buttonMode')) pdo['buttonMode'] = !data || data.buttonMode;
			
			//mouseChildren (default = false)
			if (pdo.hasOwnProperty('mouseChildren')) pdo['mouseChildren'] = data && data.mouseChildren;
			
			//injectMouseEvent (default = false)
			if (data && data.injectMouseEvent) {
				_addWithEventParams(pdo, onOver, onOut, onClick, params, data);
			} else if (params) {
				_addWithParams(pdo, onOver, onOut, onClick, params, data);
			} else {
				_addWithEvent(pdo, onOver, onOut, onClick, data);
			}
		}
		
		private static function _loop(func: Function, targets: Array, onClick:*, params: Array, ...rest): void {
			var onClickI	: * ;
			var paramsI		: Array;
			
			for (var i: int = 0; i < targets.length; i++) {
				if (onClick is Array) {
					onClickI	= onClick[i];
					
					if (onClickI is Function) {//use default params
						paramsI		= [targets[i], onClickI, params]
					} else if (onClickI is Array) {//use custom params
						paramsI		= [targets[i], onClickI.shift(), onClickI]
					} else {
						logger('_loop', 'fail processing ['+ targets[i] + '] at index '+i+' : - onClick item should be Function / Array[function, param1, param2 .... ]');
						continue;
					}
				} else {
					paramsI		= [targets[i], onClick, params]
				}
				
				paramsI.push.apply(null, rest);
				func.apply(null, paramsI);
			}
		}
		
	/************************
	 * 		STATIC APIs
	 ***********************/	
		
		public static function remove(pdo : Object): void {
			var info 	: ButtonInfo	= _map[pdo];
			if (info) {
				if (info.onOver != null)  pdo.removeEventListener(MouseEvent.ROLL_OVER, info.onOver);
				if (info.onOut != null)	  pdo.removeEventListener(MouseEvent.ROLL_OUT, info.onOut);
				if (info.onClick != null) pdo.removeEventListener(MouseEvent.CLICK, info.onClick);
				delete _map[pdo];
			} else {
				logger('remove', 'fail as target is has not yet registered ['+pdo+']');
			}
		}
		
	/************************
	 * 		EVENT PASS
	 ***********************/	
		
		private static function _addWithEvent(pdo: InteractiveObject, onOver: Function, onOut: Function, onClick: Function, data: Object = null): void {
			_map[pdo] = new ButtonInfo(onOver, onOut, onClick, data);
			
			if (onOver != null)  pdo.addEventListener(MouseEvent.ROLL_OVER, onOver, false, 0, true);
			if (onOut != null)	 pdo.addEventListener(MouseEvent.ROLL_OUT, onOut, false, 0, true);
			if (onClick != null) pdo.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}
		
	/************************
	 * 		PARAMS PASS
	 ***********************/ 
		
		private static function _addWithParams(pdo: InteractiveObject, onOver: Function, onOut: Function, onClick: Function, params: Array = null, data: Object = null): void {
			_map[pdo] = new ButtonInfo(onOver, onOut, onClickWithParams, data, onClick, params);
			
			if (onOver != null)  pdo.addEventListener(MouseEvent.ROLL_OVER, onOver, false, 0, true);
			if (onOut != null)	 pdo.addEventListener(MouseEvent.ROLL_OUT, onOut, false, 0, true);
			if (onClick != null) pdo.addEventListener(MouseEvent.CLICK, onClickWithParams, false, 0, true);
		}
		
		private static function onClickWithParams(e: MouseEvent ): void {
			var info 	: ButtonInfo	= _map[e.currentTarget];
			if (info.func != null) info.func.apply(null, info.params);
		}
		
	/************************
	 * 	  EVENT + PARAMS
	 ***********************/ 
		
		private static function _addWithEventParams(pdo: InteractiveObject, onOver: Function, onOut: Function, onClick: Function, params: Array = null, data: Object = null): void {
			params.unshift(0); //the first place is for the event
			_map[pdo] = new ButtonInfo(onOver, onOut, onClickWithEventParams, data, onClick, params);
			
			if (onOver != null)  pdo.addEventListener(MouseEvent.ROLL_OVER, onOver, false, 0, true);
			if (onOut != null)	 pdo.addEventListener(MouseEvent.ROLL_OUT, onOut, false, 0, true);
			if (onClick != null) pdo.addEventListener(MouseEvent.CLICK, onClickWithEventParams, false, 0, true);
		}
		
		private static function onClickWithEventParams(e: MouseEvent): void {
			var info 	: ButtonInfo	= _map[e.currentTarget];
			info.params[0] = e;
			if (info.func != null) info.func.apply(null, info.params);
		}	
		
	/************************
	 * 		AS - ALPHA
	 ***********************/
		
	 /**
	  * make an interactive object a button
	  * @param	pdo an interactive object or an Array of them
	  * @param	onClick a function / an Array of [func] or [func, params1, param2 ...]]
	  * @param	params default parameters for every onClick callbacks
	  * @param	config special parameters - overAlpha=0.7, outAlpha=1, injectMouseEvent=false, buttonMode=true, mouseChildren=false 
	  */
		public static function addAlpha(pdo: * , onClick:*, params: Array = null, config: Object = null): void {
			if (pdo is Array) {
				_loop(addAlpha, pdo, onClick, params, config);
				return;
			}
			
			var code : int = check(pdo);
			
			switch (code) {
				case 1 :	logger('addAlpha', 'failed with a non-interactive target [' + pdo + ']'); break;
				case 2 :	logger('addAlpha', 'overwritten as target has already registered [' + pdo + ']'); //there are no break here !
							remove(pdo);
				case 3 : 	_add(pdo as InteractiveObject, _onAlphaOver, _onAlphaOut, onClick, params, config); break;
			}
		}
		
		private static function _onAlphaOver(e: Event): void {
			var pdo		: Object		= e.currentTarget;
			var info 	: ButtonInfo	= _map[pdo];
			
			pdo.alpha 	= info.data ? info.data.overAlpha || 0.5 : 0.5;
		}
		
		private static function _onAlphaOut(e: Event): void {
			var pdo		: Object		= e.currentTarget;
			var info 	: ButtonInfo	= _map[pdo];
			pdo.alpha 	= info.data ? info.data.outAlpha || 1: 1;
		}
		
	/************************
	 * 	NONE : NO OVER / OUT
	 ***********************/	
		
		public static function addNone(pdo: *, onClick:*, params: Array = null, config: Object = null): void {
			if (pdo is Array) {
				_loop(addNone, pdo, onClick, params, config);
				return;
			}
			
			var code : int = check(pdo);
			
			switch (code) {
				case 1 :	logger('addNone', 'failed with a non-interactive target [' + pdo + ']'); break;
				case 2 :	logger('addNone', 'overwritten as target has already registered [' + pdo + ']'); //no break here !
							remove(pdo);
				case 3 :	_add(pdo as InteractiveObject, null, null, onClick, params, config); break;
			}
		}
		
	/************************
	 * 		FRAME LABEL
	 ***********************/	
		
		static public function addLabel(pdo: * , onClick:*, params: Array = null, config: Object = null):void {
			if (pdo is Array) {
				_loop(addLabel, pdo, onClick, params, config);
				return;
			}
			
			var code : int = check(pdo);
			
			switch (code) {
				case 1 :	logger('addLabel', 'failed with a non-interactive target [' + pdo + ']'); break;
				case 2 :	logger('addLabel', 'overwritten as target has already registered [' + pdo + ']'); //there are no break here !
							remove(pdo);
				case 3 : 	_add(pdo as InteractiveObject, _onLabelOver, _onLabelOut, onClick, params, config); break;
			}
		}
		
		private static function _onLabelOver(e: Event): void {
			var pdo		: Object		= e.currentTarget;
			var info 	: ButtonInfo	= _map[pdo];
			pdo.gotoAndStop(info.data ? info.data.overLabel : 'over');
		}
		
		private static function _onLabelOut(e: Event): void {
			var pdo		: Object		= e.currentTarget;
			var info 	: ButtonInfo	= _map[pdo];
			pdo.gotoAndStop(info.data ? info.data.outLabel : 'out');
		}
		
	}
}

class ButtonInfo {//use to remove events later on
	public var onOver	: Function;
	public var onOut	: Function;
	public var onClick	: Function;
	
	//store style data
	public var data		: Object;
	
	//for custom parameters
	public var func		: Function;
	public var params	: Array;
	
	public function ButtonInfo(onOver: Function, onOut: Function, onClick: Function, data: Object, func: Function = null, params: Array = null) {
		this.onOver		= onOver;
		this.onOut		= onOut;
		this.onClick	= onClick;
		this.data		= data;
		
		this.func 		= func;
		this.params		= params;
	}
}