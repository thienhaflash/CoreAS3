package vn.flash.display.shortcut 
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function format(textfield: TextField, formatObj: Object, useAsDefault:Boolean = true): TextField { /* small secrets : useDefaults : true */
		if (!formatObj || !textfield) return textfield;
		
		var tff		: TextFormat	= textfield.getTextFormat();
		
		if (formatObj.useDefaults) {
			formatObj['autoSize']			= TextFieldAutoSize.LEFT;
			formatObj['selectable']			= false;
			formatObj['mouseWheelEnabled']	= false;
			formatObj['mouseEnabled']		= false;
			delete formatObj.useDefaults;
		}
		
		for (var prop : String in formatObj) {
			FormatData.formatProps[prop] ? tff[prop] = formatObj[prop] : textfield[prop] = formatObj[prop];
		}
		textfield.setTextFormat(tff);
		if (useAsDefault) textfield.defaultTextFormat = tff;
		return textfield;
	}
}

class FormatData {
	public static var formatProps : Object = { align: 1, blockIndent: 1, bold: 1, bullet: 1, color: 1, font: 1, indent: 1, italic: 1, italic: 1, kerning: 1, leading: 1, leftMargin: 1, letterSpacing: 1, rightMargin: 1, size: 1, tabStops: 1, target: 1, underline: 1, url: 1 };
}