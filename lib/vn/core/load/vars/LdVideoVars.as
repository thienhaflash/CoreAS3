package vn.core.load.vars 
{
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	/**
	 * LdVideoVars : variables used by LdVideo plugin used to ensure strong typing to end users
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * 
	 */
	public class LdVideoVars extends LdVars
	{
		public var stream 			: NetStream;
		public var connection		: NetConnection;
		public var video			: Video;
		
		public var metaData			: Object;
		public var duration			: Number;
	}

}