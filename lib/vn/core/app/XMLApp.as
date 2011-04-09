package vn.core.app
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getTimer;
	import vn.core.load.constant.LdStatus;
	import vn.core.load.core.LdEvent;
	import vn.core.load.core.LdQueue;
	import vn.core.load.utils.loadURL;
	/**
	 * A quicker way to set up common simple flash applications
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.0
	 * @updated	22 March 2011
	 * 
	 * @features
	 * 		Support Flashvars, AppPath, AppDebug, AppCache, AppConfig
	 * 		
	 * @todo
	 * 		Support auto parsing module configuration using dot syntax (moduleId.moduleVars)
	 * 		Support dependency resource loads to supplies to modules
	 * 		Support 2 frames assets preloader
	 * 		Support refresh/reset application (?)
	 * 		Support external debugger module load (?)
	 * 		
	 */ 
	public class XMLApp extends MovieClip
	{
		protected var assets		: Object; /* reference to preloaded assets included appConfig */
		
		protected var appVars		: Object;
		protected var appConfig		: AppConfig;
		protected var appLoader		: LdQueue;
		
		protected var appConfigURL	: String;
		
		public function XMLApp() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function get appConfigXML(): XML { return appConfig.xmlData; }
		
		protected function onAddedToStage(e: Event = null): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.scaleMode	= StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			//set app flash vars
			setAppVars(root.loaderInfo.parameters);
		}
		
		public function setAppVars(pvars: Object): void {
			//if vars already set, just return 
			appVars			= pvars;
			appConfigURL	= appVars['appConfig'] || appConfigURL;
			assets			= { };
			
			appLoader = LdQueue.getQueue('main', true);//use the main queue
			
			if (appConfigURL != null) {
				loadURL(appConfigURL)
							.on_ERROR(trace, ['[XMLApp : appConfigURL=' + appConfigURL + ' not found]'])
							.on_COMPLETED(onAppConfigLoaded);
			} else {
				appConfig = new AppConfig();
				initApp();
			}
		}
		
		private function onAppConfigLoaded():void 
		{
			appConfig = new AppConfig(appLoader.dataVars.dataAsXML);
			
			for (var id : String in appConfig.assetURL) {
				loadURL(appConfig.assetURL[id], id)
							.on_COMPLETED(onAssetLoaded, [id]);
			}
			appLoader.on_QUEUE_STATUS(onQueueStatus);
		}
		
		private function onQueueStatus():void 
		{
			if (appLoader.status == LdStatus.QUEUE_IDLE) {//all asset loaded : can not use once here
				appLoader.dispatcher.removeListenerOrCallback(LdEvent.QUEUE_STATUS, onQueueStatus);
				initApp();
			}
		}
		
		private function onAssetLoaded(id:String):void 
		{
			assets[id] = appLoader.currentLoader.vars.loadedContent; /* don't care what type of content is */
			//if (appConfig.isDebug) trace('Loaded asset id=', id, ' content=', assets[id]);
		}
		
		
	/****************************
	 * 		CORE FUNCTIONS
	 ***************************/
		
		public function onStageResize(e:Event):void 
		{
			stage.removeEventListener(Event.ENTER_FRAME, onStageResize); //auto remove listener if not overriden
		}
		
		public function initApp(): void {
			trace(this,'.initApp() is the entrance of your application, it need to be overriden !');
		}
		
		public function resetApp(newAppConfigPath: String = null): void {
			//TODO : dispose all assets, clean all loading queues, remove all listeners
			if (newAppConfigPath) {
				appConfigURL = newAppConfigPath;
				appLoader	.addURL(newAppConfigPath)
							.on_COMPLETED(onAppConfigLoaded);
			} else {
				initApp();
			}
		}
		
	/******************
	 * 		UTILS
	 *****************/
		
		//public function getLink(url: String): String {
			//return appPath + url + (appCache ? '?t=' + getTimer() +'' + Math.random() : '');
		//}
	}
}

class AppConfig {
	public var isDebug		: Boolean;
	public var allowCache	: Boolean;
	public var assetURL		: Object; /* asset id to data url */
	public var baseURL		: String;
	public var xmlData		: XML;
	
	public function AppConfig(xml: XML = null) {
		xmlData = xml;
		assetURL = { };
		
		if (xml) {
			isDebug		= xml.@isDebug 		== 'true';
			allowCache	= xml.@allowCache	== 'false';
			baseURL		= xml.@baseURL || '';
			
			var l			: int = xml.asset.length();
			var  xmlItem	: XML;
			for (var i: int = 0; i < l; i++) {
				xmlItem = xml.asset[i];
				assetURL[xmlItem.@id] = xmlItem.@url;
			}
		} else {
			isDebug		= false;
			allowCache	= true;
		}
	}
}
