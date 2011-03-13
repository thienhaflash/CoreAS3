package vn.core.load 
{
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import vn.core.event.Dispatcher;
	import vn.core.event.IDispatcher;
	import vn.core.load.core.LdQueue;
	import vn.core.load.core.LdVars;
	/**
	 * ...
	 * @author 
	 */
	public class SLoad
	{	
		protected var _impl		: * ;
		
		public function SLoad(id: *) {
			if (!ldQueueClass) ldQueueClass	= getDefinitionByName('vn.core.load.core.LdQueue') as Class;
			if (ldQueueClass) _impl	= new ldQueueClass(id);
		}
		
		
		
		public static function getItem(idOrUrl: String, autoNew: Boolean = true): LdVars { return null};
		
		protected static var ldQueueClass	: Class;
		protected static var queues			: Dictionary = new Dictionary();
		
		public static function get mainQueue(): SLoad {
			if (!_mainQueue) _mainQueue		= new SLoad('main');
			return _mainQueue;
		}
		
		public static function getQueue(queueId: * , autoNew: Boolean = true): SLoad {
			queues
		};
		
	/********************************
	 * 		LOADING API
	 *******************************/	
		
		public function add(urlOrRequest : * , prioritize : String = LdPriority.QUEUE_FIRST, id: String = null): LdVars {
			var _data	: LdVars;
			var _url	: String	= urlOrRequest is  URLRequest ? (urlOrRequest as  URLRequest).url : urlOrRequest;
			
			if (_impl && _url) {//ignore if urlOrRequest is Null
				_data		=	_impl.get(_url, id, true);//get existed one or create new
				if (urlOrRequest is URLRequest) _data.request = urlOrRequest;
				_impl.add(_data, prioritize, id);
			}
			return _data;
		}
		
		//public function preload(urlOrRequest : String, stopAtPercentOrBytes: Number = 1, id: String = null): LdVars {
			//if (_impl) {//use preload counter (?)
				//_data.stopAt = stopAtPercentOrBytes;
			//}
			//return this;
		//}
		
		public function remove(urlOrId: String): LdVars {
			return null;
		}
		
		public function get(urlOrId: String): LdVars {
			return null;
		}
		
		
	}
}



