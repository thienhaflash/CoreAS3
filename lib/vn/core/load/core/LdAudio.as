package vn.core.load.core 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import vn.core.load.constant.LdType;
	import vn.core.load.core.LdBase;
	/**
	 * ...
	 * @author 
	 */
	public class LdAudio extends LdBase
	{
		public var id3 		: ID3Info;
		public var sound	: Sound;
		public var channel	: SoundChannel;
		public var context	: SoundLoaderContext;
		public var duration	: Number;
		
		override public function get type():String { return LdType.AUDIO; }
		
		override protected function _startLoad():void 
		{
			var snd : Sound = new Sound();
			sound = snd;
			snd.addEventListener(Event.COMPLETE, 			_onComplete);
			snd.addEventListener(ProgressEvent.PROGRESS,	_onProgress);
			snd.addEventListener(IOErrorEvent.IO_ERROR,		_onError);
			snd.addEventListener(Event.ID3, 				_onInfo);
			snd.addEventListener(Event.OPEN, 				_onInfo);
			
			snd.load(new URLRequest(url), context);
		}
		
		override protected function _stopLoad():void 
		{
			if (sound) {
				var snd : Sound = sound;
				snd.removeEventListener(Event.COMPLETE, 		_onComplete);
				snd.removeEventListener(ProgressEvent.PROGRESS,	_onProgress);
				snd.removeEventListener(IOErrorEvent.IO_ERROR,	_onError);				
				snd.removeEventListener(Event.ID3, 				_onInfo);
				snd.removeEventListener(Event.OPEN, 			_onInfo);
				
				sound	= null;
				context = null;
			}
		}
		
		override protected function _onInfo(e:Event):void 
		{
			if (e.type == Event.ID3) id3 = ID3Info(sound.id3);
			super._onInfo(e);
		}
		
		override public function get extension():String { return '.acc|.mp3|.f4a|.f4b'; }
	}
}