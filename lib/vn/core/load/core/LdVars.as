package vn.core.load.core 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.ApplicationDomain;
	import vn.core.event.Dispatcher;
	import vn.core.load.constant.LdType;
	import vn.core.load.LdEvent;

	public class LdVars {
		public var type			: String;
		public var id			: String;
		public var url			: String;
		public var request		: URLRequest;
		public var queue		: String;
		
		public var stopAt		: Number; //!= null means preload
		
		/* config data */
		internal var data			: * ;
		internal var contentType	: String;
		internal var method			: String;
		
		/* config video */
		internal var bufferTime		: Number;
		internal var attachVideo	: Boolean;
		internal var useNetStatus	: Boolean;
		internal var waitForMeta	: Boolean;
		internal var pauseAtStart	: Boolean;
		
		/* config audio */
		internal var duration		: Number;
		internal var checkPolicy	: Boolean;
		
		/* config graphic */
		internal var smoothBitmap	: Boolean;
		internal var appDomain		: ApplicationDomain;
		
		//clone from the default configurator here !
		
		public function LdVars(url: String, id: String = null) {
			this.url	= url;
			this.id		= id;
			this.type	= LdType.UNKNOWN;
			dispatcher = new Dispatcher();
		}
		
	/****************************
	 * 		EVENT SHORTHAND
	 ***************************/
		
		public var dispatcher	: Dispatcher;
		
		public function on_STARTED(handler: Function, params: Array = null): LdVars {
			dispatcher.addCallback(LdEvent.ITEM_START, handler, params);
			return this;
		}
		
		public function on_PROGRESS(handler: Function, params: Array = null): LdVars {
			dispatcher.addCallback(LdEvent.ITEM_PROGRESS, handler, params);
			return this;
		}
		
		public function on_INFO(handler: Function, params: Array = null): LdVars {
			dispatcher.addCallback(LdEvent.ITEM_INFO, handler, params);
			return this;
		}
		
		public function on_COMPLETED(handler: Function, params: Array = null): LdVars {
			dispatcher.addCallback(LdEvent.ITEM_COMPLETE, handler, params);
			return this;
		}
		
		public function on_ERROR(handler: Function, params: Array = null): LdVars {
			dispatcher.addCallback(LdEvent.ITEM_ERROR, handler, params);
			return this;
		}
		
	/****************************
	 * 		CONFIGURATORS
	 ***************************/
		
		public function configData(byteArrayOrObject : * = null, contentType: String = null, method: String = null): LdVars {
			this.data			= byteArrayOrObject;
			this.contentType	= contentType;
			this.method			= method ? method : URLRequestMethod.POST;
			this.type			= LdType.DATA;
			return this;
		}
		
		public function configVideo(bufferTime: Number = 1, duration: Number = 0, useNetStatus: Boolean = true, checkPolicy : Boolean = true, pauseAtStart: Boolean = true, attachVideo: Boolean = false, waitForMeta: Boolean = true): LdVars {
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
		
		public function configAudio(bufferTime: Number = 10, duration: Number = 0, checkPolicy: Boolean = true): LdVars {
			this.bufferTime		= bufferTime;
			this.duration		= duration;
			this.checkPolicy	= checkPolicy;
			this.type			= LdType.AUDIO;
			
			return this;
		}
		
		public function configGraphic(smoothBitmap:Boolean = true, checkPolicy: Boolean = true, appDomain: ApplicationDomain = null): LdVars {
			this.smoothBitmap	= smoothBitmap;
			this.checkPolicy	= checkPolicy;
			this.appDomain		= appDomain ? appDomain : ApplicationDomain.currentDomain;
			this.type			= LdType.GRAPHIC;
			return this;
		}
		
		public function toString(): String {
			return '[LdVars type=' + type + ' url=' + url + ']';
		}
	}

}