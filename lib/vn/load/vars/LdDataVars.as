package vn.load.vars 
{
	import flash.net.URLLoader;
	import flash.text.StyleSheet;
	import vn.load.constant.LdType;
	/**
	 * ...
	 * @author 
	 */
	public class LdDataVars extends LdVars
	{
		public var urlLoader	: URLLoader;
		private var _css		: StyleSheet;
		private var _xml		: XML;
		
		//public function get data(): * {
			//return _loadedContent;
		//}
		
		public function get dataAsCSS(): StyleSheet {
			if (!_css) _css = new StyleSheet();
			_css.parseCSS(loadedContent);
			return _css;
		}
		
		public function get dataAsXML(): XML {
			if (!_xml) _xml = XML(loadedContent);
			return _xml;
		}
	}

}