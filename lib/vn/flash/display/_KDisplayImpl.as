package vn.flash.display 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	import vn.flash.display.shortcut.*;
	
	/**
	 * ...
	 * @author thienhaflash
	 */
	internal class _KDisplayImpl implements IKDisplay
	{
		
	/************************
	 * 		GLOBAL
	 ***********************/
		
		public function get stage():Stage {
			return flashstage;
		}
		
		public function get root():DisplayObject {
			return flashroot;
		}
		
	/************************
	 * 		ADD CHILDREN
	 ***********************/
		
		public function addChildren(parent:Object, children:Array, at:int = -1):void {
			vn.flash.display.shortcut.addChildren(parent, children, at);
		}
		
		public function addChildrenByNames(parent:Object, names:*):void {
			vn.flash.display.shortcut.addChildrenByNames(parent, names);
		}
		
	/************************
	 * 		GET CHILDREN
	 ***********************/	
		
		public function getChildren(parent:Object, fromTop:Boolean = false, ignoreCount:int = 0):Array {
			return vn.flash.display.shortcut.getChildren(parent, fromTop, ignoreCount);
		}
		
		public function getChildrenByNames(parent:Object, names:*):Array {
			return vn.flash.display.shortcut.getChildrenByNames(parent, names);
		}
		
		public function getChildrenExceptNames(parent:Object, exceptNames:*):Array {
			return vn.flash.display.shortcut.getChildrenExceptNames(parent, exceptNames);
		}
		
	/************************
	 * 	REMOVE CHILDREN
	 ***********************/	
		
		public function removeChildren(parent:Object, returnChildren:Boolean = false, fromTop:Boolean = false, ignoreCount:int = 0):Array {
			return vn.flash.display.shortcut.removeChildren(parent, returnChildren, fromTop, ignoreCount);
		}
		
		public function removeChildrenByNames(parent:Object, names:*, returnChildren:Boolean = false):Array {
			return vn.flash.display.shortcut.removeChildrenByNames(parent, names, returnChildren);
		}
		
		public function removeChildrenExceptNames(parent:Object, exceptNames:*, returnRemovedDO:Boolean = false):Array {
			return vn.flash.display.shortcut.removeChildrenExceptNames(parent, exceptNames, returnRemovedDO);
		}
		
		public function remove(target:Object):DisplayObject {
			return vn.flash.display.shortcut.remove(target);
		}
		
	/************************
	 * 		FILTERS
	 ***********************/	
		
		public function blur(target:Object, blurX:Number = 4.0, blurY:Number = 4.0, quality:int = 1):void {
			vn.flash.display.shortcut.blur(target, blurX, blurY, quality);
		}
		
		public function dropShadow(target: Object, distance:Number = 4.0, angle:Number = 45, color:uint = 0, alpha:Number = 1.0, blurX:Number = 4.0, blurY:Number = 4.0, strength:Number = 1.0, quality:int = 1, inner:Boolean = false, knockout:Boolean = false, hideObject:Boolean = false): void {
			vn.flash.display.shortcut.dropShadow(target, distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
		}
		
		public function glow(target: Object, color:uint = 0xFF0000, alpha:Number = 1.0, blurX:Number = 6.0, blurY:Number = 6.0, strength:Number = 2, quality:int = 1, inner:Boolean = false, knockout:Boolean = false) : void {
			vn.flash.display.shortcut.glow(target, color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		public function bevel(target:Object, distance:Number = 4.0, angle:Number = 45, highlightColor:uint = 0xFFFFFF, highlightAlpha:Number = 1.0, shadowColor:uint = 0x000000, shadowAlpha:Number = 1.0, blurX:Number = 4.0, blurY:Number = 4.0, strength:Number = 1, quality:int = 1, type:String = "inner", knockout:Boolean = false):void {
			vn.flash.display.shortcut.bevel(target, distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, blurX, blurY, strength, quality, type, knockout);
		}
		
	/************************
	 * 		TRANSFORM
	 ***********************/
		
		public function rotateAround(target: Object, x: Number, y: Number, angle: Number): void {
			vn.flash.display.shortcut.rotateAround(target, x, y, angle);
		}
		
		public function scaleAround(target: Object, x: Number, y: Number, sx: Number, sy: Number, oMatrix: Matrix = null) : void {
			vn.flash.display.shortcut.scaleAround(target, x, y, sx, sy, oMatrix);
		}
		
	/************************
	 * 		OTHERS
	 ***********************/	
		
		public function format(textfield:TextField, formatObj:Object, useAsDefault:Boolean = true):void {
			vn.flash.display.shortcut.format(textfield, formatObj, useAsDefault);
		}
		
		public function setMouse(target:Object, mouseEnabled:Boolean = false, buttonMode:Boolean = false, mouseChildren:Boolean = false):void {
			vn.flash.display.shortcut.setMouse(target, mouseEnabled, buttonMode, mouseChildren);
		}
		
		public function tint(target:Object, color:int, amount:Number = 1):void {
			vn.flash.display.shortcut.tint(target, color, amount);
		}
		
		public function grayscale(target:Object, amount:Number = 1):void {
			vn.flash.display.shortcut.grayscale(target, amount);
		}
		
		public function brightness(target:Object, amount:Number = 1):void {
			vn.flash.display.shortcut.brightness(target, amount);
		}
		
	}
}