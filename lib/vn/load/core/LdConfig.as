package vn.load.core 
{
	/**
	 * LdConfig save loading items config and listeners to be used later on by loader plugins
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	21 March 2011
	 * 
	 */
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	import vn.core.event.Dispatcher;
	import vn.load.constant.LdType;

	public class LdConfig {
		public var type			: String;
		public var id			: String;
		public var url			: String;
		public var request		: URLRequest;
		public var queue		: String;
		
		public var stopAt		: Number; //!= null means preload
		
		/* config data */
		public var sendData		: * ;
		public var contentType	: String;
		public var method		: String;
		
		/* config video */
		public var bufferTime	: Number;
		public var attachVideo	: Boolean;
		public var useNetStatus	: Boolean;
		public var waitForMeta	: Boolean;
		public var pauseAtStart	: Boolean;
		
		/* config audio */
		public var duration		: Number;
		public var checkPolicy	: Boolean;
		
		/* config graphic */
		public var smoothBitmap	: Boolean;
		public var appDomain	: ApplicationDomain;
		public var secuDomain	: SecurityDomain;
		
		//clone from the default configurator here !
		
		public function LdConfig(url: String, id: String = null) {
			this.url	= url;
			this.id		= id;
			this.type	= LdType.UNKNOWN;
			dispatcher = new Dispatcher();
		}
		
	/****************************
	 * 		EVENT SHORTHAND
	 ***************************/
		
		public var dispatcher	: Dispatcher;
		
		public function on_STARTED(handler: Function, params: Array = null): LdConfig {
			dispatcher.addCallback(LdEvent.ITEM_START, handler, params);
			return this;
		}
		
		public function on_PROGRESS(handler: Function, params: Array = null): LdConfig {
			dispatcher.addCallback(LdEvent.ITEM_PROGRESS, handler, params);
			return this;
		}
		
		public function on_INFO(handler: Function, params: Array = null): LdConfig {
			dispatcher.addCallback(LdEvent.ITEM_INFO, handler, params);
			return this;
		}
		
		public function on_COMPLETED(handler: Function, params: Array = null): LdConfig {
			dispatcher.addCallback(LdEvent.ITEM_COMPLETE, handler, params);
			return this;
		}
		
		public function on_ERROR(handler: Function, params: Array = null): LdConfig {
			dispatcher.addCallback(LdEvent.ITEM_ERROR, handler, params);
			return this;
		}
		
	/****************************
	 * 		CONFIGURATORS
	 ***************************/
		
		public function configData(byteArrayOrObject : * = null, contentType: String = null, method: String = null): LdConfig {
			this.sendData		= byteArrayOrObject;
			this.contentType	= contentType;
			this.method			= method ? method : URLRequestMethod.POST;
			this.type			= LdType.DATA;
			return this;
		}
		
		public function configVideo(bufferTime: Number = 1, duration: Number = 0, useNetStatus: Boolean = true, checkPolicy : Boolean = true, pauseAtStart: Boolean = true, attachVideo: Boolean = false, waitForMeta: Boolean = true): LdConfig {
			this.bufferTime		= bufferTime;
			this.attachVideo	= attachVideo;
			this.waitForMeta	= waitForMeta;
			this.duration		= duration;
			this.checkPolicy	= checkPolicy;
			this.useNetStatus	= useNetStatus;
			this.pauseAtStart	= pauseAtStart;
			this.type			= LdType.VIDEO;
			return this;
		}
		
		public function configAudio(bufferTime: Number = 10, duration: Number = 0, checkPolicy: Boolean = true): LdConfig {
			this.bufferTime		= bufferTime;
			this.duration		= duration;
			this.checkPolicy	= checkPolicy;
			this.type			= LdType.AUDIO;
			return this;
		}
		
		public function configGraphic(smoothBitmap:Boolean = true, checkPolicy: Boolean = true, appDomain: ApplicationDomain = null, secuDomain: SecurityDomain = null): LdConfig {
			this.smoothBitmap	= smoothBitmap;
			this.checkPolicy	= checkPolicy;
			this.appDomain		= appDomain ? appDomain : ApplicationDomain.currentDomain;
			this.secuDomain		= secuDomain;
			this.type			= LdType.GRAPHIC;
			return this;
		}
		
		public function toString(): String {
			return '[LdConfig type=' + type + ' url=' + url + ']';
		}
	}

}