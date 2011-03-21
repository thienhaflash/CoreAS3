package vn.load.vars 
{
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import vn.load.constant.LdType;
	/**
	 * ...
	 * @author 
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