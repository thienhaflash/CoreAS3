package vn.core.load.core 
{
	import flash.display.Shape;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import vn.core.load.constant.LdType;
	import vn.core.load.core.LdBase;
	/**
	 * ...
	 * @author 
	 */
	public class LdVideo extends LdBase
	{
		protected var _heart		: Shape;
		
		public var stream 			: NetStream;
		public var connection		: NetConnection;
		public var video			: Video;
		
		public var metaData			: Object;
		public var duration			: Number;
		
		//protected var _wait4Meta	: Boolean;
		//protected var _attachVideo	: Boolean;
		//protected var _useStream	: Boolean;
		//protected var _bufferTime	: Number;	
		
		public function LdVideo() 
		{
			_heart = new Shape();
			
			connection = new NetConnection();
			connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, 		_onError);
			connection.addEventListener(IOErrorEvent.IO_ERROR, 				_onError);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onError);
			connection.connect(null);
			
			stream = new NetStream(connection);
			stream.client = { onMetaData : _onMetaData };//onCuePoint, on..
		}
		
		override protected function _startLoad():void 
		{
			//var ud : Object = vars;
			//
			//waitMeta		= !(ud.waitMeta == false);		//default : true
			//pauseAtStart	= !(ud.pauseAtStart == false);	//default : true
			//useNetStatus	= ud.useNetStatus == true;		//default : false
			//closeStream	= !ud.useNetStatus;//if using NetStatus - don't close the stream automatically when loaded
			
			//stream.checkPolicyFile = false;
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, 	_onError);
			stream.addEventListener(IOErrorEvent.IO_ERROR, 			_onError);
			//if (useNetStatus) stream.addEventListener(NetStatusEvent.NET_STATUS,		_onNetStatus);
			stream.play(_vars.url);
			//if (pauseAtStart) stream.pause();
			_heart.addEventListener(Event.ENTER_FRAME, _updateProgress);
		}
		
		private function _updateProgress(e:Event):void 
		{
			var stream	: NetStream = stream;
			var pct : Number = stream.bytesLoaded / stream.bytesTotal;
			
			_bytesLoaded = stream.bytesLoaded;
			_bytesTotal = stream.bytesTotal;
			_percent = pct;
			
			if (pct >= 1) {
				_heart.removeEventListener(Event.ENTER_FRAME, _updateProgress);
				if (!_vars.waitForMeta || metaData != null) {
					stopLoad();
				}				
			}
		}
		
		private function _onNetStatus(e:NetStatusEvent):void 
		{
			_event = e;
		}
		
		private function _onMetaData(info: Object):void
		{
			if (_vars.waitForMeta && percent >= 1) {
				stopLoad();
			}
		}
		
		override public function stopLoad():void 
		{
			//if (closeStream) {
				//try {
					//stream.close();//stop stream only if it's loading ?
				//} catch (e: Error) { };
			//}
			
			stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, 	_onError);
			stream.removeEventListener(IOErrorEvent.IO_ERROR, 			_onError);
			stream.removeEventListener(NetStatusEvent.NET_STATUS,		_onInfo);
		}
		override public function get type():String { return LdType.VIDEO; }
		override public function get extension():String { return '.avi|.mp4|.flv|.f4v|.f4p|.mov'; }
	}

}