package vn.load.vars 
{
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import vn.load.constant.LdType;
	/**
	 * ...
	 * @author 
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