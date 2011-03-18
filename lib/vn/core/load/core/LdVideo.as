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
	import vn.core.event.EnterFrame;
	import vn.core.load.constant.LdType;
	import vn.core.load.core.LdBase;
	/**
	 * ...
	 * @author 
	 */
	public class LdVideo extends LdBase
	{
		public var stream 			: NetStream;
		public var connection		: NetConnection;
		public var video			: Video;
		
		public var metaData			: Object;
		public var duration			: Number;
		
		public function LdVideo() 
		{
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
			stream.checkPolicyFile = _vars.checkPolicy;
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, 	_onError);
			stream.addEventListener(IOErrorEvent.IO_ERROR, 			_onError);
			if (_vars.useNetStatus) stream.addEventListener(NetStatusEvent.NET_STATUS,		_onNetStatus);
			stream.play(_vars.url);
			if (_vars.pauseAtStart) stream.pause();
			EnterFrame.onEach(_updateProgress);
		}
		
		private function _updateProgress():void 
		{
			var stream	: NetStream = stream;
			var pct : Number = stream.bytesLoaded / stream.bytesTotal;
			
			_bytesLoaded = stream.bytesLoaded;
			_bytesTotal = stream.bytesTotal;
			_percent = pct;
			
			if (pct >= 1) {
				EnterFrame.remove_onEach(_updateProgress);
				if (!_vars.waitForMeta || metaData != null) {
					stopLoad();
				}
				super._onComplete(null);
			} else {
				super._onProgress(null);
			}
		}
		
		private function _onNetStatus(e:NetStatusEvent):void 
		{
			_event = e;
		}
		
		private function _onMetaData(info: Object):void
		{
			metaData = info;
			super._onInfo(null);
			
			if (_vars.waitForMeta && _percent >= 1) {
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