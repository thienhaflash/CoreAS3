package vn.core {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public class LocalLoader {
		public static const TYPE_AUTO			: int = 0;
		public static const TYPE_BYTE_ARRAY		: int = 1;
		public static const TYPE_STRING			: int = 2;
		public static const TYPE_XML			: int = 3;
		public static const TYPE_DISPLAY_OBJECT : int = 4;
		
		private static var _main : LocalLoader;
		public static function get main(): LocalLoader {
			return _main ||= new LocalLoader();
		};
		
		private var _fileRef	: FileReference;
		private var _ld			: Loader;
		private var _rawData	: ByteArray;
		private var _content	: * ;
		
		private var _type		: int;
		private var _isLoading	: Boolean;
		private var _onCancel	: Function;
		private var _onComplete	: Function;
		
		public function LocalLoader() {
			_fileRef = new FileReference();
			_fileRef.addEventListener(Event.SELECT, onSelectFileHandler);
			_fileRef.addEventListener(Event.CANCEL, onCancelSelectFileHandler);
		}
		
		public function browse(hint: String, extension: String, type: int = 0, onComplete: Function = null, onCancel: Function = null): void {
			if (_isLoading) {
				trace('The LocalLoader instance is still loading a file, please wait until it completes or create a new instance - action canceled');
				return;
			}
			
			_type 			= (type == TYPE_AUTO) ? getType(extension) : type;
			_onCancel		= onCancel;
			_onComplete		= onComplete;
			
			//clear old contents
			_ld				= null;
			_rawData		= null;
			_content		= null;
			
			_fileRef.browse([new FileFilter(hint, extension)]);
		}
		
		private function getType(extension : String): int {
			var ldType : int;
			switch (extension) {
				case '*.jpg' :
				case '*.png' :
				case '*.swf' :
				case '*.gif' :
					ldType = TYPE_DISPLAY_OBJECT;
					break;
					
				case '*.xml' : 
					ldType = TYPE_XML;
					break;
					
				case '*.txt' : 
				case '*.csv' : 
					ldType = TYPE_STRING
					break;
				default 	:
					ldType = TYPE_BYTE_ARRAY;
			}
			
			return ldType;
		}
		
		private function onCancelSelectFileHandler(evt:Event):void {
			//_fileRef.removeEventListener(Event.SELECT, onSelectFileHandler);
			//_fileRef.removeEventListener(Event.CANCEL, onCancelSelectFileHandler);
			if (_onCancel != null) _onCancel();
		}
		
		private function onSelectFileHandler(evt:Event):void {
			_isLoading = true;
			
			trace('onSelect :: ', _fileRef.name);
			//_fileRef.removeEventListener(Event.SELECT, onSelectFileHandler);
			//_fileRef.removeEventListener(Event.CANCEL, onCancelSelectFileHandler);
			_fileRef.addEventListener(Event.COMPLETE, onCompleteLoadFileHandler);
			_fileRef.load();
		}
		
		private function onCompleteLoadFileHandler(evt:Event):void {
			trace('onCompleteLoadFileHandler : ', _type);
			
			_fileRef.removeEventListener(Event.COMPLETE, onCompleteLoadFileHandler);
			_rawData = _fileRef.data;
			
			_isLoading	= false;
			switch (_type) {
				case TYPE_BYTE_ARRAY 		:
					_content	= _rawData; break;
					
				case TYPE_STRING	 		:
					_content = _rawData.readUTFBytes(_rawData.bytesAvailable); break;
					
				case TYPE_XML		 		:
					_content = new XML(_rawData.readUTFBytes(_rawData.bytesAvailable)); break;
					
				case TYPE_DISPLAY_OBJECT	:
					_isLoading = true;
					_ld = new Loader();
					_ld.loadBytes(_rawData);
					_ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoadContent);
					break;
			}
			
			if (!_isLoading && _onComplete != null) _onComplete(_content);
		}
		
		private function onCompleteLoadContent(e:Event):void {
			_content	= _ld.content;
			_isLoading	= false;
			if (_onComplete != null) _onComplete(_content);
		}
		
		public function get content(): * {
			return _isLoading ? null : _content;
		}
		
		public function save(data: ByteArray, name: String): void {
			_fileRef = new FileReference();
			_fileRef.save(data, name);
		}
		
		public function get loader(): Loader {
			return _ld;
		}
		
		public function get rawData():ByteArray {
			return _rawData;
		}
		
		public function get fileName(): String {
			return _fileRef.name;
		}
	}
}