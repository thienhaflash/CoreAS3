package vn.core.load.core 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.StyleSheet;
	import vn.core.load.constant.LdType;
	import vn.core.load.core.LdBase;
	/**
	 * ...
	 * @author 
	 */
	public class LdData extends LdBase
	{
		public var urlLoader	: URLLoader;
		public var data			: * ;
		
		private var _css		: StyleSheet;
		private var _xml		: XML;
		
		public function get dataAsCSS(): StyleSheet {
			if (!_css) _css = new StyleSheet();
			_css.parseCSS(data);
			return _css;
		}
		
		public function get dataAsXML(): XML {
			if (!_xml) _xml = XML(data);
			return _xml;
		}
		
		override protected function _startLoad():void 
		{
			var request : URLRequest = new URLRequest(url);
			var obj 	: Object// = variables;
			if (obj) {
				var variables : URLVariables = new URLVariables();
				for (var s : String in obj) {
					variables[s] = obj[s];
				}
				request.data = variables;
				request.method = URLRequestMethod.POST;
			}
			
			var ld : URLLoader = new URLLoader();
			urlLoader = ld;
			ld.addEventListener(Event.COMPLETE, 					_onComplete);
			ld.addEventListener(ProgressEvent.PROGRESS, 			_onProgress);
			ld.addEventListener(IOErrorEvent.IO_ERROR, 				_onError);
			ld.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onError);
			
			ld.load(request);
		}
		
		override protected function _stopLoad():void 
		{
			if (urlLoader) {
				var ld : URLLoader = urlLoader;
				try { ld.close() } catch (e: Error) { }
				ld.removeEventListener(Event.COMPLETE, 						_onComplete);
				ld.removeEventListener(ProgressEvent.PROGRESS, 				_onProgress);
				ld.removeEventListener(IOErrorEvent.IO_ERROR, 				_onError);
				ld.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onError);
				urlLoader = null;
			}
			
			data = null;
			urlLoader = null;
			//variables = null;
		}
		
		override protected function _onComplete(e:Event):void 
		{
			data = urlLoader.data;
			super._onComplete(e);
		}
		override public function get type():String { return LdType.DATA; }
		override public function get extension():String { return '.xml|.txt|.css'; }
	}

}