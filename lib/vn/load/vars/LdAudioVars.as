package vn.load.vars 
{
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import vn.load.constant.LdType;
	/**
	 * LdAudioVars : variables used by LdAudio plugin and used to ensure strong typing to end users
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * 
	 */
	public class LdAudioVars extends LdVars
	{
		public var id3 		: ID3Info;
		public var sound	: Sound;
		public var context	: SoundLoaderContext = new SoundLoaderContext();
		public var channel	: SoundChannel;
		public var duration	: Number;
	}

}