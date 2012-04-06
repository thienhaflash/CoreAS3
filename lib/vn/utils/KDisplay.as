package vn.utils {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.IBitmapDrawable;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * DisplayObject shorthand collection to quickly remove / add / get children, make transform, add filters ...
	 * 
	 * @author	thienhaflash (thienhaflash@gmail.com)
	 * @version 0.1.1
	 * @updated	08 November 2011
	 * @features	supported common displayObject operations addChilren/ getChildren / removeChildren ...
	 * 				Creation		: newShape, newSprite, newMovieClip, newTextField, cloneDO
	 * 				Interaction 	: setMouse / hitTestMouse
	 * 				Filters			: blur, glow, dropshadow, bevel, grayscale
	 * 				ColorTransform	: tint, brightness
	 * 				Transform		: rotateAround / scaleAround
	 * 				Size			: getRect / getBound
	 * 				TextField		: formatText
	 *				MovieClip		: getFrameLabel, distributeProp
	 * 				Bitmap			: draw, drawMask
	 * 				Graphics		: drawRect, drawArc
	 * 				Align/Scale		: distribute, grid
	 * 				Flashvars		: 
	 * 				ContextMenu		: 
	 *	 			Loader			: loadIcon, loadImage
	 *				
	 */
	public class KDisplay {
		
		public static var version		: String	= '0.1.1';
		public static var traceErrors	: Boolean	= true;
		
		public static var root			: DisplayObject;
		public static var stage			: Stage;
		
		public static function showError(functionName: String, ...rest): void {
			if (!traceErrors) return;
			
			var s	: String = 'KDisplay.' + functionName + ' fail with';
			var tmp	: String;
			var l	: int = rest.length;
			var cdo	: DisplayObject;
			
			for (var i: int = 0; i < l; i += 2) {
				cdo = rest[i + 1];
				
				if (cdo) {
					tmp = cdo.name || String(cdo);
					while (cdo.parent) { //get full name from the root
						cdo = cdo.parent;
						if (cdo == cdo.stage) {
							tmp = 'stage.' + tmp;
							break;
						}
						tmp = (cdo.name || cdo) +'.' + tmp;
					}
					s += ' [' + rest[i] + '=' + tmp + ']';
				} else {
					s += ' [' + rest[i] + '=' + rest[i + 1] +']';
				}
			}
			
			trace(s);
		}
		
	
	/*****************************
	 * 		DISPLAY LIST
	 ****************************/
		
		public static function getIndex(pChild : Object): int {
			var cdo : DisplayObject = pChild as DisplayObject;
			
			if (cdo && cdo.parent) {
				return cdo.parent.getChildIndex(cdo);
			} else {
				showError('getIndex', 'pChild', pChild);
			}
			return -1;
		}
		
		public static function setIndex(pChild : Object, idx : int): void {
			var cdo : DisplayObject = pChild as DisplayObject;
			
			if (cdo && cdo.parent) {
				cdo.parent.setChildIndex(cdo, idx);
			} else {
				showError('setIndex', 'pChild', pChild, 'idx', idx);
			}
		}
		/*
		
		//MIGHT NOT VERY USEFUL OR SAFE WAY TO DO
		
		public static function replace(pNew: Object, pOld: Object): void {
			if (pOld && pOld.parent && pNew){
				pOld.parent.addChildAt(pNew, getIndex(pOld));
				remove(pOld);
			} else {
				showError('replace', 'pNew', pNew, 'pOld', pOld);
			}
		}
		
		public static function replaceAt(pNew: Object, pParent: Object, pIndex: int): void {
			pParent.numChildren > pIndex ? replace(pNew, pParent.getChildAt(pIndex)) : pParent.addChild(pNew);
		}
		*/
		
		public static function removeChildren(parent:Object, returnChildren:Boolean = false, fromTop:Boolean = false, ignoreCount:int = 0):Array {
			var pp	: DisplayObjectContainer = parent as DisplayObjectContainer;
			
			if (pp) {
				var ch	: Array	= returnChildren ? [] : null;
				var n	: int	= pp.numChildren;
				var cdo	: DisplayObject;
				
				while (--n >= ignoreCount) {
					cdo = pp.removeChildAt(fromTop ? n : 0);
					if (returnChildren) ch.push(cdo);
				}
			} else {
				showError('removeChildrenByNames', 'parent', pp);
			}
			
			return ch;
		}
		
		public static function removeChildrenByNames(parent: Object, names: *, returnChildren: Boolean = false): Array {
			var pp	: DisplayObjectContainer = parent as DisplayObjectContainer;
			if (pp) {
				var cdo	: DisplayObject;
				var arr : Array = returnChildren ? [] : null;
				
				names = names is Array ? names : [names];
				for (var i: int = names.length-1; i > -1; i--) {
					cdo = pp.getChildByName(names[i]) || parent[names[i]];
					if (cdo && cdo.parent == pp) {
						returnChildren ? arr.push(pp.removeChild(cdo)) : pp.removeChild(cdo);
					} else {
						if (returnChildren) showError('removeChildrenByNames', 'parent', pp, names[i], cdo);
					}
				}
			} else {
				showError('removeChildrenByNames', 'parent', pp);
			}
			return arr;
		}
		
		public static function removeChildrenExceptNames(parent: Object, exceptNames: * , returnRemovedDO : Boolean = false): Array {
			var pp	: DisplayObjectContainer = parent as DisplayObjectContainer;
			var arr	: Array = (exceptNames as Array) || [exceptNames];
			var cdo	: DisplayObject;
			var ch	: Array = returnRemovedDO ? [] : null;
			
			if (pp) {
				for (var i: int = pp.numChildren - 1; i > -1; i--) {
					cdo	= pp.getChildAt(i);
					if (cdo && arr.indexOf(cdo.name) == -1) {
						pp.removeChild(cdo);
						if (returnRemovedDO) ch.push(cdo);
					}
				}
			} else {
				showError('removeChildrenByNames', 'parent', pp);
			}
			return ch;
		}
		
		public static function removeDO(pChild: Object): DisplayObject {
			var cdo : DisplayObject = pChild as DisplayObject;
			
			if (cdo && pChild.parent) {
				cdo.parent.removeChild(cdo);
			} else {
				showError('removeChildrenByNames', 'pChild', pChild);
			}
			
			return cdo;
		}
		
		
		public static function addChildrenByNames(parent: Object, names: * ): void {
			var pp	: DisplayObjectContainer = parent as DisplayObjectContainer;
			var cdo	: DisplayObject;
			var ch	: Array = (names as Array) || [names];
			
			if (pp) {
				for (var i: int = ch.length - 1; i > -1; i--) {
					cdo = parent[ch[i]];
					if (cdo) pp.addChild(cdo);
				}
			} else {
				showError('addChildrenByNames', 'parent', parent, names);
			}
		}
		
		public static function addChildren(parent: Object, children: Array, at: int = -1) : void {
			var pp	: DisplayObjectContainer = parent as DisplayObjectContainer;
			if (pp) {
				for (var i: int = children.length-1; i > -1; i--) {
					at == -1 ? pp.addChild(children[i]) : pp.addChildAt(children[i], at);
				}
			} else {
				showError('addChildren', 'parent', parent, children);
			}
		}
		
		
		public static function getChildrenExceptNames(parent: Object, exceptNames: *): Array {
			var pp	: DisplayObjectContainer = parent as DisplayObjectContainer;
			var arr	: Array = (exceptNames as Array) || [exceptNames];
			var cdo	: DisplayObject;
			var ch	: Array = [];
			
			if (pp) {
				for (var i: int = pp.numChildren - 1; i > -1; i--) {
					cdo	= pp.getChildAt(i);
					if (cdo && arr.indexOf(cdo.name) == -1) ch.push(cdo);
				}
			} else {
				showError('getChildrenExceptNames', 'parent', parent, exceptNames);
			}
			
			return ch;
		}
		
		public static function getChildrenByNames(parent: Object, names: *): Array {
			var pp	: DisplayObjectContainer = parent as DisplayObjectContainer;
			var ch	: Array =  (names as Array) || [names];
			
			if (pp) {
				for (var i: int = ch.length - 1; i > -1; i--) {
					ch[i] = pp.getChildByName(ch[i]) || parent[ch[i]];
				}
			} else {
				showError('getChildrenByNames', 'parent', parent, names);
			}
			
			return ch;
		}
		
		public static function getChildren(parent: Object, fromTop : Boolean = false, ignoreCount : int = 0): Array {
			var pp	: DisplayObjectContainer = parent as DisplayObjectContainer;
			var n	: int = pp.numChildren;
			var ch : Array = [];
			
			if (pp) {
				for (var i: int = n - ignoreCount-1; i > -1 ; i--) {
					ch.push(fromTop ? pp.getChildAt(n-i-1) : pp.getChildAt(i));
				}
			} else {
				showError('getChildren', 'parent', parent);
			}
			
			return ch;
		}
		
	/*****************************
	 * 		CREATION
	 ****************************/	
		
		public static function newMask(pDO : Object, w: int, h: int): Shape {
			var cdo	: DisplayObject = pDO as DisplayObject;
			if (cdo) {
				var shp : Shape = drawRect(new Shape(), 0, 100, 100) as Shape;
				if (cdo.parent) cdo.parent.addChild(shp);
				
				shp.x		= cdo.x;
				shp.y		= cdo.y;
				shp.width	= w;
				shp.height	= h;
				cdo.mask	= shp;
			} else {
				showError('newMask', 'pDO', pDO);
			}
			return shp;
		}
		
		public static function newTextField(parent: Object = null, isInput: Boolean = false, w: int = 150, h: int = 25, x: int = 0, y: int = 0): TextField {
			var tf : TextField = formatTextField(new TextField(), { type		: isInput ? TextFieldType.INPUT : TextFieldType.DYNAMIC
																	, multiline	: false
																	, x			: x
																	, y			: y
																	, width		: w
																	, height	: h
																	, size		: 16 } );
			var pp : DisplayObjectContainer = parent as DisplayObjectContainer;
			pp ? pp.addChild(tf) : showError('newTextField', 'parent', parent);
			
			return tf;
		}
		
		public function newBitmapData(w: int, h: int, src: IBitmapDrawable, bmd: BitmapData = null): BitmapData {
			if (!bmd || bmd.width != w || bmd.height != h) {
				bmd = new BitmapData(w, h, true, 0x00ffffff);
			}
			bmd.draw(src, null, null, null, null, true);
			return bmd;
		}
		
		public function cloneDO(source: * ): DisplayObject {
			var obj : Object;
			
			if (source) {
				switch (true) {
					case source is Bitmap	: //Clone a Bitmap	: reuse BitmapData
						obj = new Bitmap((source as Bitmap).bitmapData, 'auto', true); break;
					case source is String	: //Clone a ClassName : find the class first - no break !	
						source = getDefinitionByName(source) as Class;
					case source is Class	: //Clone a Class : just new
						if (getQualifiedClassName(source) == 'flash.display::MovieClip') showError('cloneDO', 'className', source);
						obj = new (source as Class)();
						break;
					default	: obj = new source.constructor();
				}
			} else {
				showError('cloneDO', 'source', source);
			}
			
			return obj as DisplayObject;
		}
		
		public static function populateProps(props: Object, ...list): void {
			var itm : * ;
			var l	: int = list.length;
			for (var i: int = 0; i < l; i++) {
				itm = list[i];
				
				for (var s : String in props) {
					itm[s] = props[s];
				}
			}
		}
		
	/*****************************
	 * 		ALIGN / SCALE
	 ****************************/		
		
		public static function hzDistribute(spacing: int = 0, ...list):void {
			var l : int = list.length;
			var x : int = list[0].x;
			for (var i: int = 0; i < l; i++) {
				list[i].x = x;
				x += list[i].width + spacing;
			}
		}
		
	/*****************************
	 * 		SIZE / BOUND
	 ****************************/	
		
		/** 
		 * get the boundary of an Object from its parent's coordinate
		 */
		private static var sprt : Sprite = new Sprite();
		
		public static function getBound(pDO: Object):Rectangle {
			var cdo : DisplayObject = cdo as DisplayObject;
			
			if (cdo) {
				if (!cdo.parent) sprt.addChild(cdo);
				var bound : Rectangle = cdo.getBounds(cdo.parent);
				removeChildren(sprt);
			} else {
				showError('getBound', 'pDO', pDO);
			}
			
			return bound;
		}
		
		/**
		 * get the rect of an Object from its parent's coordinate
		 */
		public static function getRect(pDO: DisplayObject): Rectangle {
			var cdo : DisplayObject = pDO as DisplayObject;
			
			if (cdo) {
				if (!cdo.parent) sprt.addChild(cdo);
				var rect : Rectangle = cdo.getRect(cdo.parent);
				removeChildren(sprt);
			} else {
				showError('getRect', 'pDO', pDO);
			}
			
			return rect;
		}
		
	/*****************************
	 * 		INTERACTION
	 ****************************/
		
		/**
		 * @param	cdo the interactive object that will be reset mouse-interaction
		 */
		public static function setMouse(pDO: Object, pMouseEnabled: Boolean = false, pButtonMode: Boolean  = false, pMouseChildren: Boolean = false): void {
			var cdo : InteractiveObject = pDO as InteractiveObject;
			
			if (cdo) {
				cdo.mouseEnabled	= pMouseEnabled;
				var sprt : Sprite		= cdo as Sprite;
				
				if (sprt) {
					sprt.buttonMode		= pButtonMode;
					sprt.mouseChildren	= pMouseChildren;
				}
			} else {
				showError('setMouse', 'pDO', pDO);
			}
		}
		
		/**
		 * @param	pDOs array of objects to be reset mouse-interaction
		 */
		public static function setMultiMouse(pDOs: Array, pMouseEnabled : Boolean = false, pButtonMode: Boolean  = false, pMouseChildren : Boolean = false): void {
			if (pDOs) {
				var i: int;
				var l: int = pDOs.length;
				
				for (i = 0; i < l; i++ ) {
					setMouse(pDOs[i], pMouseEnabled, pButtonMode, pMouseChildren);
				}
			} else {
				showError('setMultiMouse', 'pDOs', pDOs);
			}
		}
		
		public static function hitTestMouse(pDO: DisplayObject, shapeFlag : Boolean): Boolean {
			var cdo : DisplayObject = pDO as DisplayObject;
			
			if (!cdo) showError('hitTestMouse', 'pDO', pDO);
			return pDO && cdo.stage ? cdo.hitTestPoint(cdo.stage.mouseX, cdo.stage.mouseY, shapeFlag) : false;
		}
		
	/*****************************
	 * 		COLOR TRANSFORM
	 ****************************/
		
		public static function tint(pDO : Object, color: int, amount: Number = 1): void {
			var cdo : DisplayObject = pDO as DisplayObject;
			
			if (cdo) {
				var ct	: ColorTransform = new ColorTransform();
				ct.color			= color;
				ct.redOffset		= amount * ct.redOffset;
				ct.greenOffset		= amount * ct.greenOffset;
				ct.blueOffset		= amount * ct.blueOffset;
				
				ct.redMultiplier	= 1 - amount;
				ct.greenMultiplier	= 1 - amount;
				ct.blueMultiplier	= 1 - amount;
				
				(cdo as DisplayObject).transform.colorTransform = ct;
			} else {
				showError('tint', 'pDO', pDO);
			}
		}
		
		public static function brightness(pDO : Object, amount: Number = 1): void {
			var cdo : DisplayObject = pDO as DisplayObject;
			
			if (!cdo) {
				var ct	: ColorTransform = new ColorTransform();
				var val	: int = amount * 255;
				
				ct.redOffset	= val;
				ct.greenOffset	= val;
				ct.blueOffset	= val;
				cdo.transform.colorTransform = ct;
			} else {
				showError('brightness', 'pDO', pDO);
			}
		}
		
	/*****************************
	 * 		FILTERS
	 ****************************/
		
		public static function dropshadow(pDO: Object, distance:Number = 4.0, angle:Number = 45, color:uint = 0, alpha:Number = 1.0, blurX:Number = 4.0, blurY:Number = 4.0, strength:Number = 1.0, quality:int = 1, inner:Boolean = false, knockout:Boolean = false, hideObject:Boolean = false):void {
			var cdo : DisplayObject = pDO as DisplayObject;
			
			cdo ? cdo.filters = [new DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject)]
				: showError('dropshadow', 'pDO', pDO);
		}
		
		public static function blur(pDO: Object, blurX:Number = 4.0, blurY:Number = 4.0, quality:int = 1):void {
			var cdo : DisplayObject = pDO as DisplayObject;
			
			cdo ? cdo.filters = (blurX == 0 && blurY == 0) ? [] : [new BlurFilter(blurX, blurY, quality)]
				: showError('blur', 'pDO', pDO);
		}
		
		public static function bevel(pDO: Object, distance:Number = 4.0, angle:Number = 45, highlightColor:uint = 0xFFFFFF, highlightAlpha:Number = 1.0, shadowColor:uint = 0x000000, shadowAlpha:Number = 1.0, blurX:Number = 4.0, blurY:Number = 4.0, strength:Number = 1, quality:int = 1, type:String = "inner", knockout:Boolean = false):void {
			var cdo : DisplayObject = pDO as DisplayObject;
			
			cdo ? cdo.filters = [new BevelFilter(distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, blurX, blurY, strength, quality, type, knockout)]
				: showError('bevel', 'pDO', pDO);
		}
		
		public static function glow(pDO: Object, color:uint = 0xFF0000, alpha:Number = 1.0, blurX:Number = 6.0, blurY:Number = 6.0, strength:Number = 2, quality:int = 1, inner:Boolean = false, knockout:Boolean = false):void {
			var cdo : DisplayObject = pDO as DisplayObject;
			
			cdo ? cdo.filters = [new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout)]
				: showError('glow', 'pDO', pDO);
		}
		
		public static function grayscale(pDO: Object, amount: Number = 1): void {
			var cdo : DisplayObject = pDO as DisplayObject;
			
			if (cdo) {
				if (amount > 0 ) {
					var r : Number = 0.3086;
					var g : Number = 0.6094;
					var b : Number = 0.0820;
					var a : Number = amount;
					var d : Number = 1 - amount;
					
					(cdo as DisplayObject).filters = [
						new ColorMatrixFilter([	a * r + d	, a * g		, a * b		, 0, 0,
												a * r		, a * g + d	, a * b		, 0, 0,
												a * r		, a * g		, a * b + d	, 0, 0,
												0, 0, 0, 1, 0])
					]
				} else {
					(cdo as DisplayObject).filters = [];
				}
			} else {
				showError('grayscale', 'pDO', pDO);
			}
		}
		
		/**
		 * draw an arc
		 * @param	graphics the graphics that will be drawn
		 * @param	ox x origin
		 * @param	oy y orign
		 * @param	r radius
		 * @param	stAngle start drawing angle
		 * @param	edAngle end drawing angle
		 * @return
		 */
		public static function drawArc(pDO: Object, ox: int, oy: int, r: Number, stAngle: Number, edAngle: Number): DisplayObject {
			var nAngles : int = Math.ceil((edAngle-stAngle) / 45);
			var sAngle : Number = (edAngle-stAngle) / nAngles * Math.PI/180;//always smaller than 45 and more than 45/2
			
			var cAngle : Number = stAngle * Math.PI / 180;
			var rMid	: Number = r / Math.cos(sAngle / 2);
			
			var g	: Graphics =		(pDO is Sprite) ? (pDO as Sprite).graphics
									:	(pDO is Shape) ? (pDO as Shape).graphics : null;
			if (g) {
				g.moveTo(ox + r * Math.cos(cAngle), oy + r * Math.sin(cAngle));
			
				for (var i: int = 0; i < nAngles; i++) {
					g.curveTo(rMid * Math.cos(cAngle + sAngle / 2), rMid * Math.sin(cAngle + sAngle / 2), 
									r * Math.cos(cAngle + sAngle), r * Math.sin(cAngle + sAngle));
					cAngle += sAngle;
				}
			} else {
				showError('drawArc', 'pDO', pDO);
			}
			return pDO as DisplayObject;
		}
		
		/**
		 * draw a rectangle into a DisplayObject's graphics
		 * @param	pDO the DisplayObject who graphics to be drawn
		 * @param	pcolor the color to be drawn
		 * @param	pwidth the desired width
		 * @param	pheight the desired height
		 * @param	palpha the drawing alpha
		 * @return
		 */
		public static function drawRect(pDO: Object, pcolor: int = 0xEAEAEA, pwidth: int = 100, pheight: int = 100, palpha: Number = 1) : DisplayObject {
			var g	: Graphics =		(pDO is Sprite) ? (pDO as Sprite).graphics
									:	(pDO is Shape) ? (pDO as Shape).graphics : null;
			
			if (g) {
				g.beginFill(pcolor, palpha);
				g.drawRect(0, 0, pwidth, pheight);
				g.endFill();
			} else {
				showError('drawRect', 'pDO', pDO);
			}
			return pDO as DisplayObject;
		}
		
	/******************
	 * 		TEXT
	 *****************/
		
		private static var formatProps : Object = { align: 1, blockIndent: 1, bold: 1, bullet: 1, color: 1, font: 1, indent: 1, italic: 1, italic: 1, kerning: 1, leading: 1, leftMargin: 1, letterSpacing: 1, rightMargin: 1, size: 1, tabStops: 1, target: 1, underline: 1, url: 1 };
		
		public static function formatTextField(textfield: TextField, formatObj: Object, useAsDefault:Boolean = true): TextField { /* small secrets : useDefaults : true */
			if (textfield) {
				var tff		: TextFormat	= textfield.getTextFormat();
				if (formatObj) {
					if (formatObj.useDefaults) {
						formatObj['autoSize']			= TextFieldAutoSize.LEFT;
						formatObj['selectable']			= false;
						formatObj['mouseWheelEnabled']	= false;
						formatObj['mouseEnabled']		= false;
						formatObj['blendMode']			= BlendMode.LAYER;
						delete formatObj.useDefaults;
					}
					
					for (var prop : String in formatObj) {
						formatProps[prop] ? tff[prop] = formatObj[prop] : textfield[prop] = formatObj[prop];
					}
					textfield.setTextFormat(tff);
				}
				if (useAsDefault) textfield.defaultTextFormat = tff;
			} else {
				showError('formatTextfield', 'textfield', textfield, 'formatObj', formatObj);
			}
			
			return textfield;
		}
	 
	/*****************************
	 * 		TRANSFORM
	 ****************************/
	 
		public static function scaleAround(pDO: Object, x: Number, y: Number, sx: Number, sy: Number, oMatrix: Matrix = null) : void {
			var cdo : DisplayObject = pDO as DisplayObject;
			var m	: Matrix;
			/*
				Maple 14 syntax : evalm(`&*`(`&*`(Matrix(3, 3, {(1, 1) = 1, (1, 2) = 0, (1, 3) = x0, (2, 1) = 0, (2, 2) = 1, (2, 3) = y0, (3, 1) = 0, (3, 2) = 0, (3, 3) = 1}), Matrix(3, 3, {(1, 1) = sx, (1, 2) = 0, (1, 3) = 0, (2, 1) = 0, (2, 2) = sy, (2, 3) = 0, (3, 1) = 0, (3, 2) = 0, (3, 3) = 1})), Matrix(3, 3, {(1, 1) = 1, (1, 2) = 0, (1, 3) = -x0, (2, 1) = 0, (2, 2) = 1, (2, 3) = -y0, (3, 1) = 0, (3, 2) = 0, (3, 3) = 1})))
				
				|1	0	x|		|sx		0		0|		|1	0	-x|		|sx		0		x*(1-sx)|
				|0	1	y|	*	|1		sy		0|	*	|0	1	-y|	 =	|0		sy		y*(1-sy)|
				|0	0	1|      |0		0		1|      |0	0	1 |     |0		0		1		|
				
			*/
			if (cdo) {
				if (oMatrix) {
					m = oMatrix.clone();
					m.concat(new Matrix(sx, 0, 0, sy, x * (1 - sx), y * (1 - sy)));
				} else {
					m = new Matrix(sx, 0, 0, sy, x * (1 - sx), y * (1 - sy));
				}
				(cdo as DisplayObject).transform.matrix = m;
			} else {
				showError('scaleAround', 'pDO', pDO);
			}
		}
		
		public static function rotateAround(pDO: Object, x: Number, y: Number, angle: Number, oMatrix: Matrix = null): void {
			angle *= Math.PI / 180;
			var cdo : DisplayObject = pDO as DisplayObject;
			var sin : Number = Math.sin(angle);
			var cos : Number = Math.cos(angle);
			var m	: Matrix;
			
			/*
				Maple 14 syntax : evalm(`&*`(`&*`(Matrix(3, 3, {(1, 1) = 1, (1, 2) = 0, (1, 3) = x0, (2, 1) = 0, (2, 2) = 1, (2, 3) = y0, (3, 1) = 0, (3, 2) = 0, (3, 3) = 1}), Matrix(3, 3, {(1, 1) = cos, (1, 2) = -sin, (1, 3) = 0, (2, 1) = sin, (2, 2) = cos, (2, 3) = 0, (3, 1) = 0, (3, 2) = 0, (3, 3) = 1})), Matrix(3, 3, {(1, 1) = 1, (1, 2) = 0, (1, 3) = -x0, (2, 1) = 0, (2, 2) = 1, (2, 3) = -y0, (3, 1) = 0, (3, 2) = 0, (3, 3) = 1})))
				
				|1	0	x|		|cos	-sin	0|		|1	0	-x|		|cos	-sin	-cos*x+sin*y+x	|
				|0	1	y|	*	|sin	cos		0|	*	|0	1	-y|	 =	|sin	cos		-sin*x-cos*y+y	|
				|0	0	1|      |0		0		1|      |0	0	1 |     |0		0		1				|
				
			*/
			
			if (cdo) {
				if (oMatrix) {
					m = oMatrix.clone();
					m.concat(new Matrix(cos, sin, -sin, cos, -cos * x + sin * y + x, -sin * x - cos * y + y));
				} else {
					m = new Matrix(cos, sin, -sin, cos, -cos * x + sin * y + x, -sin * x - cos * y + y);
				}
				(cdo as DisplayObject).transform.matrix = m;
			} else {
				showError('rotateAround', 'pDO', pDO);
			}
		}
	}
}
