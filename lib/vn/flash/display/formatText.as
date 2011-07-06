package vn.flash.display 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function formatText(textfield: TextField, format: Object): TextField {
		var tff				: TextFormat	= textfield.getTextFormat();
		var isFormatProp	: Object		= _displayVars.txtFormat;
		
		for (var prop : String in pFormat) {
			isFormatProp[prop] ? tff[prop] = format[prop] : textfield[prop] = format[prop];
		}
		textfield.setTextFormat(tff);
		textfield.defaultTextFormat = tff;
	}
}