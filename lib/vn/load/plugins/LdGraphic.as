package vn.load.plugins 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.getQualifiedClassName;
	import vn.load.constant.LdType;
	import vn.load.core.LdBase;
	import vn.load.vars.LdGraphicVars;
	import vn.load.vars.LdVars;
	/**
	 * ...
	 * @author 
	 */
	public class LdGraphic extends LdBase
	{
		protected var _vars : LdGraphicVars = new LdGraphicVars();
		
		//override public function startLoad(url:String, userData:Object = null):void 
		//{
			//stopLoad();//check if it's loading
			//url = url;
			//
			//if (userData) {//parse userData object
				//userData = userData;
				//
				//context = userData.context; //can be null
				//cacheMode = (userData.cacheMode != null) ? userData.cacheMode : 1; //default to CLONE
				//trace('mode :: ', cacheMode, userData.cacheMode);
				//smoothBitmap = (userData.smoothBitmap != null) ? userData.cacheBitmap : true; //default to true
			//}
			//
			//var _content	: DisplayObject;
			//
			//if (cacheMode > 0) {//CLONE or UNIQUE
				//_content = _cacher.fromURL(url);
				//trace('cache contentt :: ', _content);
				//if (_content && cacheMode == 1) {//CLONE MODE
					//if (_content is Bitmap) {
						//_content = new Bitmap((_content as Bitmap).bitmapData, 'auto', true);
					//} else if (_content is MovieClip){
						//var cls : Class = (_content as Object).constructor as Class;
						//_content = getQualifiedClassName(_content) == 'flash.display.MovieClip' ? null : (new cls() as DisplayObject);
					//}
				//}
			//}
			//
			//var li : LoaderInfo;
			//if (_content) {//has cached content
				//content = _content;
				//_callback('START');
				//_callback('COMPLETE');
			//} else {
				//
				//
				///* 	continuosly creating new Loader seems not to be very efficient, but it will solve the 2 problems with loader
				//firstly		a loader can only start after it completedly unload old content - 
						//if we trying to call a .load() right after an .unload() with non-null content 
						//we may not be able to access the newly load content
				//secondly	.loaderInfo is the same for same-loader content, that means, if we use a loader to load multiple 
						//files, .loaderInfo from loaded contents will point to the lasted load one, which is not the 
						//information for that content
				//*/
				//
				//
				//
				//_callback('START');
			//}
		//}
		
		override protected function _startLoad():void 
		{
			if (!_config.request) _config.request = new URLRequest(_config.url);
			var context : LoaderContext = _vars.context;
			context.applicationDomain	= _config.appDomain;
			context.checkPolicyFile		= _config.checkPolicy;
			context.securityDomain		= _config.secuDomain;
			
			_vars.loader = new Loader();
			var li : LoaderInfo = _vars.loader.contentLoaderInfo;
				
			li.addEventListener(Event.COMPLETE,						_onComplete);
			li.addEventListener(ProgressEvent.PROGRESS, 			_onProgress);
			li.addEventListener(IOErrorEvent.IO_ERROR,				_onError)
			li.addEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onError)
			li.addEventListener(HTTPStatusEvent.HTTP_STATUS,		_onInfo);
			li.addEventListener(Event.INIT,							_onInfo);
			li.addEventListener(Event.OPEN,							_onInfo);
			
			_vars.loader.load(_config.request, context);
		}
		
		override protected function _stopLoad():void 
		{
			if (_vars.loader) {
				var li : LoaderInfo = _vars.loader.contentLoaderInfo;
				li.removeEventListener(Event.COMPLETE,						_onComplete);
				li.removeEventListener(ProgressEvent.PROGRESS, 				_onProgress);
				li.removeEventListener(IOErrorEvent.IO_ERROR,				_onError);			
				li.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,	_onError);
				li.removeEventListener(HTTPStatusEvent.HTTP_STATUS,			_onInfo);
				li.removeEventListener(Event.INIT,							_onInfo);
				li.removeEventListener(Event.OPEN,							_onInfo);
				
				try { _vars.loader['unloadAndStop'](); } catch (e: Error) { }//flash 10 only
				try { _vars.loader.close(); } catch (e: Error) { }
				if (_vars.loadedContent) try { _vars.loader.unload() } catch (e: Error) { };
				_vars.loader = null;
			}
			
			_vars.loadedContent = null; //content can be non-null (cached) while loader is null
		}
		
		override protected function _onComplete(e:Event):void 
		{
			if (e) {
				_vars.loadedContent = (e.currentTarget as LoaderInfo).loader.content;
				//TODO : check against security issues while retrieving .content from loader
				if (_config.smoothBitmap && _vars.loadedContent is Bitmap) (_vars.loadedContent as Bitmap).smoothing = true;
			}
			super._onComplete(e);
		}
		
		override public function get vars():LdVars { return _vars; }
		
		override public function get type():String { return LdType.GRAPHIC; }
		override public function get extension():String { return '.jpg|.png|.gif|.swf' }
	}

}