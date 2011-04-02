package vn.core.data 
{
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author thienhaflash
	 */
	public class VOData 
	{
		protected var _info 		: Dictionary;
		protected var _map			: Object;
		protected var _ignoreEmpty	: Boolean;
		
		public function VOData(ignoreEmpty : Boolean = true) 
		{
			_info			= new Dictionary();
			_map			= { };
			_ignoreEmpty	= ignoreEmpty;
		}
		
		public function addVOClass(nodeName: String, voClass: Class): VOData { /* consider support nodeLevel & map Injection */
			_map[nodeName] = voClass;
			return this;
		}
		
		public function parseXML(xml: XML): VOData {
			addVO(xml, null, 0, 0);
			return this;
		}
		
		protected function addVO(xml: XML, parentId: String, index: int, level: int): * {
			var atts	: XMLList	= xml.attributes();
			var childs	: XMLList	= xml.children();	
			var l1		: int		= atts.length();
			var l2		: int		= childs.length();			
			var cnn		: String;
			
			if (l2 > 0) {//try to get the name from the last one only, check if it's in the _map then it's the child !
				var s	: String = String((childs[l2 - 1] as XML).name());
				if (_map[s]) cnn = s;
			}
			
			var others	: XMLList 	= childs.(name() != cnn);
			
			var cls		: Class		= (l1 == 0 && (others.length() == 0) && _ignoreEmpty) ? VOEmpty : _map[String(xml.name())];
			var vo		: *			= new cls();
			var voi		: VOInfo	= new VOInfo(parentId, index, level);
			var des		: XML		= describeType(vo);
			
			if (l1 > 0) {
				dataCast(vo, atts, des);
			} else if (l2 > 0) {
				dataCast(vo, others, des);
			}
			
			_info[vo]		= voi;
			_info[voi.id]	= vo;
			
			if (cnn) {//has children
				childs	= xml[cnn];
				l2		= childs.length();
				if (l2 > 0) voi.children = addChildren(childs, voi.id, level + 1);
			}
			
			return vo;
		}
		
		protected function dataCast(vo: * , props: XMLList , voDes : XML): void {
			var l 	: int = props.length();
			var xml	: XML;
			var tmp	: XML;
			
			for (var i : int = 0; i < l; i++) {
				tmp = props[i];
				vo[String(tmp.name())] = tmp.valueOf();//TODO : do cast type based on voDes
			}
		}
		
		protected function addChildren(xmllist:XMLList, voId: String, level: int): Array {
			var l	: int	= xmllist.length();
			var arr	: Array;
			if (l > 0) {
				arr = [];
				for (var i: int = 0; i < l; i++) {
					arr.push(addVO(xmllist[i], voId, i, level + 1));
				}
			}
			
			return arr;
		}
		
	/********************
	 * 		API
	 *******************/
		
		
		public function getVO(id: String): * {
			//TODO : consider parsing id strings to corresponding numbers based on level
			return _info[id]; /* info of id is vo, info of vo is voInfo */
		}
		
		public function get children(): Array {
			return getInfo('0').children;
		}
		
		public function getChildrenOf(idOrVO: * ): Array {
			var info : VOInfo = getInfo(idOrVO);
			return info ? info.children : null;
		}
		
		public function getInfo(idOrVO: * ): VOInfo {
			var vo : * = idOrVO is String ? _info[idOrVO] : idOrVO;
			return _info[vo];
		}
		
		public function getLevel(level: int, cache: Boolean = true): Array {
			return null;
		}
		
		public function getNode(name : String, cache: Boolean = true): Array {
			return null;
		}
		
	}
}

class VOEmpty {
	
}

class VOInfo {
	public var id		: String;
	public var parentId	: String;
	public var index	: int;
	public var level	: int;
	public var children	: Array; /* can be null - don't have children */ 
	
	public function VOInfo (pid: String, idx: int, l: int) {
		level		= l;
		parentId	= pid;
		index		= idx;
		id 			= (pid ? pid + '.' : '') + idx;
	}
	
	public function toString(): String {
		return '[VOInfo id=' + id + ']';
	}
}