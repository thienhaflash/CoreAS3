package vn.flash.display 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author thienhaflash
	 */
	public interface IKDisplay 
	{
		function get stage(): Stage;
		function get root(): DisplayObject;
		
		/* DISPLAY OBJECTS */
		function addChildren(parent: Object, children: Array, at: int = -1) : void;
		function addChildrenByNames(parent: Object, names: *): void;
		
		function getChildren(parent: Object, fromTop : Boolean = false, ignoreCount : int = 0): Array;
		function getChildrenByNames(parent: Object, names: *): Array;
		function getChildrenExceptNames(parent: Object, exceptNames: *): Array;
		
		function removeChildren(parent : Object, returnChildren: Boolean = false, fromTop: Boolean = false, ignoreCount: int = 0): Array;
		function removeChildrenByNames(parent: Object, names: *, returnChildren: Boolean = false): Array;
		function removeChildrenExceptNames(parent: Object, exceptNames: * , returnRemovedDO : Boolean = false): Array;
		function remove(target : Object): DisplayObject;
		
		/* TEXTFIELD */
		function format(textfield: TextField, formatObj: Object, useAsDefault:Boolean = true): void;
		
		/* INTERACTIVE OBJECT */
		function setMouse(target: Object
			, mouseEnabled: Boolean = false, buttonMode: Boolean  = false, mouseChildren: Boolean = false): void;
		
		/* COLORIZE */
		function tint(target : Object, color: int, amount: Number = 1): void;
		
		function grayscale(target: Object, amount: Number = 1): void;
		function brightness(target: Object, amount: Number = 1): void;
		//function contrast(target: Object, amount: Number = 1): void;
		//function hue(target: Object, amount: Number = 1): void;
		//function invert(target: Object, doInvert: Boolean = true): void;
		
		/* UTILS */
		function rotateAround(target: Object, x: Number, y: Number, angle: Number): void;
		function scaleAround(target: Object, x: Number, y: Number, sx: Number, sy: Number, oMatrix: Matrix = null) : void
		
		/* FILTERS */
		function blur(target: Object, blurX:Number = 4.0, blurY:Number = 4.0, quality:int = 1) : void;
		function dropShadow(target: Object, distance:Number = 4.0, angle:Number = 45, color:uint = 0, alpha:Number = 1.0, blurX:Number = 4.0, blurY:Number = 4.0, strength:Number = 1.0, quality:int = 1, inner:Boolean = false, knockout:Boolean = false, hideObject:Boolean = false): void;
		function glow(target: Object, color:uint = 0xFF0000, alpha:Number = 1.0, blurX:Number = 6.0, blurY:Number = 6.0, strength:Number = 2, quality:int = 1, inner:Boolean = false, knockout:Boolean = false) : void;
		function bevel(target: Object, distance:Number = 4.0, angle:Number = 45, highlightColor:uint = 0xFFFFFF, highlightAlpha:Number = 1.0, shadowColor:uint = 0x000000, shadowAlpha:Number = 1.0, blurX:Number = 4.0, blurY:Number = 4.0, strength:Number = 1, quality:int = 1, type:String = "inner", knockout:Boolean = false): void;
		
		//TODO : ADD SUPPORT FOR OTHER FILTERS
		
	}
	
}