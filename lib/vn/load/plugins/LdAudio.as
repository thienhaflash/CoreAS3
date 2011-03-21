package vn.load.plugins 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import vn.load.constant.LdType;
	import vn.load.core.LdBase;
	import vn.load.vars.LdAudioVars;
	import vn.load.vars.LdVars;
	/**
	 * LdAudio plugin : use to load audio files
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * 
	 */
	public class LdAudio extends LdBase
	{
		protected var _vars : LdAudioVars = new LdAudioVars();
		
		override protected function _startLoad():void 
		{
			if (!_config.request) _config.request = new URLRequest(_config.url);
			_vars.context.bufferTime		= _config.bufferTime;
			_vars.context.checkPolicyFile	= _config.checkPolicy;
			
			var snd : Sound = new Sound();
			_vars.sound		= snd;
			snd.addEventListener(Event.COMPLETE, 			_onComplete);
			snd.addEventListener(ProgressEvent.PROGRESS,	_onProgress);
			snd.addEventListener(IOErrorEvent.IO_ERROR,		_onError);
			snd.addEventListener(Event.ID3, 				_onInfo);
			snd.addEventListener(Event.OPEN, 				_onInfo);
			snd.load(_config.request, _vars.context);
		}
		
		override protected function _stopLoad():void 
		{
			var snd : Sound = _vars.sound;
			if (snd) {
				snd.removeEventListener(Event.COMPLETE, 		_onComplete);
				snd.removeEventListener(ProgressEvent.PROGRESS,	_onProgress);
				snd.removeEventListener(IOErrorEvent.IO_ERROR,	_onError);				
				snd.removeEventListener(Event.ID3, 				_onInfo);
				snd.removeEventListener(Event.OPEN, 			_onInfo);
				_vars.sound	= null;
			}
		}
		
		override protected function _onComplete(e:Event):void 
		{
			//if (isNaN(duration)) 
			_vars.duration = _vars.sound.length / 1000;
			super._onComplete(e);
		}
		
		override protected function _onInfo(e:Event):void 
		{
			if (e.type == Event.ID3) _vars.id3 = ID3Info(_vars.sound.id3);
			super._onInfo(e);
		}
		
		override public function get vars():LdVars { return _vars; }
		
		override public function get extension():String { return '.acc|.mp3|.f4a|.f4b'; }
		override public function get type():String { return LdType.AUDIO; }
	}
}