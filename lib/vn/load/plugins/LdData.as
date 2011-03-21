package vn.load.plugins 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.StyleSheet;
	import flash.utils.ByteArray;
	import vn.load.constant.LdType;
	import vn.load.core.LdBase;
	import vn.load.vars.LdDataVars;
	import vn.load.vars.LdVars;
	/**
	 * LdData plugin : use to send and load data
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * 
	 */
	public class LdData extends LdBase
	{
		protected var _vars : LdDataVars = new LdDataVars();
		
		override protected function _startLoad():void 
		{
			if (!_config.request) {
				var request : URLRequest = new URLRequest(_config.url);
				if (_config.sendData) {
					if (_config.sendData is ByteArray) {//send byteArray
						request.requestHeaders.push(new URLRequestHeader("Content-type", "application/octet-stream"));
						request.data = _config.sendData;
					} else {//send data object
						var variables : URLVariables = new URLVariables();
						for (var s : String in _config.sendData) {
							variables[s] = _config.sendData[s];
						}
						request.data = variables;
					}
					request.method = URLRequestMethod.POST;
				}
			}
			
			var ld : URLLoader = new URLLoader();
			_vars.urlLoader = ld;
			ld.addEventListener(Event.COMPLETE, 					_onComplete);
			ld.addEventListener(ProgressEvent.PROGRESS, 			_onProgress);
			ld.addEventListener(IOErrorEvent.IO_ERROR, 				_onError);
			ld.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onError);
			ld.load(request);
		}
		
		override protected function _stopLoad():void 
		{
			var ld : URLLoader = _vars.urlLoader;
			if (ld) {
				try { ld.close() } catch (e: Error) { }
				ld.removeEventListener(Event.COMPLETE, 						_onComplete);
				ld.removeEventListener(ProgressEvent.PROGRESS, 				_onProgress);
				ld.removeEventListener(IOErrorEvent.IO_ERROR, 				_onError);
				ld.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onError);
			}
			
			_vars.loadedContent	= null;
			_vars.urlLoader		= null;
		}
		
		override protected function _onComplete(e:Event):void 
		{
			_vars.loadedContent = _vars.urlLoader.data;
			super._onComplete(e);
		}
		
		override public function get vars():LdVars { return _vars; }
		
		override public function get type():String { return LdType.DATA; }
		override public function get extension():String { return '.xml|.txt|.css'; }
	}

}