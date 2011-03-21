package vn.load.plugins 
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
	import vn.load.constant.LdType;
	import vn.load.core.LdBase;
	import vn.load.vars.LdVars;
	import vn.load.vars.LdVideoVars;
	/**
	 * ...
	 * @author 
	 */
	public class LdVideo extends LdBase
	{
		protected var  _vars : LdVideoVars = new LdVideoVars();
		
		public function LdVideo() 
		{
			var nc : NetConnection = new NetConnection();
			_vars.connection = nc;
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, 		_onError);
			nc.addEventListener(IOErrorEvent.IO_ERROR, 				_onError);
			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onError);
			nc.connect(null);
			
			_vars.stream = new NetStream(nc);
			_vars.stream.client = { onMetaData : _onMetaData };//onCuePoint, on..
		}
		
		override protected function _startLoad():void 
		{	
			//TODO : consider check to change the connection if needed
			_vars.stream.checkPolicyFile = _config.checkPolicy;
			_vars.stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, 		_onError);
			_vars.stream.addEventListener(IOErrorEvent.IO_ERROR, 			_onError);
			
			if (_config.useNetStatus) _vars.stream.addEventListener(NetStatusEvent.NET_STATUS,		_onNetStatus);
			_vars.stream.play(_config.url);
			if (_config.pauseAtStart) _vars.stream.pause();
			EnterFrame.onEach(_updateProgress);
		}
		
		private function _updateProgress():void 
		{
			var stream	: NetStream = _vars.stream;
			var pct : Number = stream.bytesLoaded / stream.bytesTotal;
			
			_vars.bytesLoaded = stream.bytesLoaded;
			_vars.bytesTotal = stream.bytesTotal;
			_vars.percent = pct;
			
			if (pct >= 1) {
				EnterFrame.remove_onEach(_updateProgress);
				if (!_config.waitForMeta || _vars.metaData != null) {
					stopLoad();
				}
				super._onComplete(null);
			} else {
				super._onProgress(null);
			}
		}
		
		private function _onNetStatus(e:NetStatusEvent):void 
		{
			_vars.event = e;
		}
		
		private function _onMetaData(info: Object):void
		{
			_vars.metaData = info;
			super._onInfo(null);
			
			if (_config.waitForMeta && _vars.percent >= 1) {
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
			
			_vars.stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, 	_onError);
			_vars.stream.removeEventListener(IOErrorEvent.IO_ERROR, 			_onError);
			_vars.stream.removeEventListener(NetStatusEvent.NET_STATUS,		_onInfo);
		}
		
		override public function get vars():LdVars { return _vars; }
		
		override public function get type():String { return LdType.VIDEO; }
		override public function get extension():String { return '.avi|.mp4|.flv|.f4v|.f4p|.mov'; }
	}

}