package vn.utils 
{
	import flash.display.Bitmap;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public function cloneObj(source: *): * 
	{
		var obj : Object;
		
		switch (true) {
			case source is Bitmap	: //Clone a Bitmap	: reuse BitmapData
				obj = new Bitmap((source as Bitmap).bitmapData, 'auto', true); break;
				
			case source is String	: //Clone a ClassName : find the class first - no break !	
				source = getDefinitionByName(source) as Class;
			case source is Class	: //Clone a Class : just new
				if (getQualifiedClassName(source) == 'flash.display::MovieClip') trace(source.name + ' might not clone correctly - check linkedName !');
				obj = new (source as Class)();
				break;
				
			default	: obj = new source.constructor();
		}
		
		return obj;
	}
}