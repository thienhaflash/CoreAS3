package vn.core.draw 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.IGraphicsData;
	import flash.display.Shader;
	import flash.geom.Matrix;
	import mx.formatters.NumberBase;
	import vn.core.flash.Math2;
	/**
	 * ...
	 * @author 
	 */
	public class Draw implements IDraw
	{
		protected var g			: Graphics;
		protected var _drawingX : Number;
		protected var _drawingY	: Number;
		
		public function useGraphics(value:Graphics):IDraw {
			g = value;
			_drawingX = 0;
			_drawingY = 0;
			return this; 
		}
		
		//TODO : support ThemeObject injection : color, style, thickness ...
		//TODO : support BoxStyle drawing : register some box style, and reuse by passing the boxStyle id
		
	/**************************
	 *	MORE DRAWING API
	 *************************/
		
		public function drawArc(centerX: Number, centerY: Number, radius : Number, stAngle: Number, edAngle: Number): IDraw {
			stAngle *= Math.PI / 180;
			edAngle *= Math.PI / 180;
			
			var oAng	: Number = Math.PI / 4; //what if using dash drawing
			
			var dAng	: Number = stAngle < edAngle ? oAng : -oAng;
			var nStep	: int	 = (edAngle-stAngle) / dAng + 1;
			var l		: Number = radius / Math.cos(dAng / 2);
			
			var ang		: Number = stAngle;
			var x 		: Number = centerX + Math.cos(ang) * radius;
			var y		: Number = centerY + Math.sin(ang) * radius;
			
			g.moveTo(x, y);
			for (var i: int = 1; i < nStep; i++) {
				//g.lineStyle(i * 60 / nStep, 0x000000);
				ang += dAng;
				g.curveTo(centerX + l * Math.cos(ang - dAng / 2)
						, centerY + l * Math.sin(ang - dAng / 2)
						, centerX + radius * Math.cos(ang)
						, centerY + radius * Math.sin(ang) );
			}
			
			dAng	= (edAngle - ang) / 2;
			l		= radius / Math.cos(dAng);
			g.curveTo(	centerX + l * Math.cos(edAngle-dAng)
					,	centerY + l * Math.sin(edAngle-dAng)
					,	centerX + radius * Math.cos(edAngle)
					,	centerY + radius * Math.sin(edAngle)
				);
			
			return this;
		}
		
		public function drawSpiral(): IDraw {
			return this;
		}
		
		//public function drawDashLineTo(x: Number, y: Number, dash: Number = 5, space: Number = 5): IDraw {
			//drawDashLine(_drawingX, _drawingY, x, y, dash, space);
			//_drawingX = x;
			//_drawingY = y;
			//return this;
		//}
		
		public function drawArcTo(x: Number, y: Number, radius: Number, clockwise: Boolean = true): IDraw {
			
			return this;
		}
		
		public function drawSpiralTo(x: Number, y: Number, rounds: int, clockwise: Boolean = true): IDraw {
			
			
			
			return this;
		}
		
	/**************************
	 *		DASH SUPPORT
	 *************************/	
		
		protected var _dash		: Number;
		protected var _space	: Number;
		
		protected function drawDashLine(x1: Number, y1: Number, x2: Number, y2: Number): void {
			var dx : Number = x2 - x1;
			var dy : Number = y2 - y1;
			var n  : int	= Math.sqrt(dx * dx + dy * dy) / (_dash + _space);
			var cos : Number = _dash * Math.cos(Math.atan2(y2 - y1, x2 - x1));
			var sin	: Number = _dash * Math.sin(Math.atan2(y2 - y1, x2 - x1));
			
			dx /= n;
			dy /= n;
			
			for (var i: int = 0; i < n; i++) {
				g.moveTo(x1, y1);
				g.lineTo(x1 + cos , y1 + sin);
				x1 += dx; //more acurracy !
				y1 += dy;
			}
			
			g.lineTo(x2, y2);
		}
		
		protected function drawDashCurve(sx: Number, sy: Number, cx: Number, cy: Number, ex: Number, ey: Number): void {
			var l	: Number = Math2.getCurveLength(sx, sy, cx, cy, ex, ey);
			var n	: int = l / (_dash + _space);
			
			var mx	: Number = cx + (ex - cx) * i / n;
			var my	: Number;
			
			
			for (var i: int = 0 ; i < n + 1; i++) {
				mx = sx + (cx - sx) * t;
				my = sy + (cy - sy) * t;
				
				g.moveTo(sx, sy);
				g.curveTo(cx + (ex-cx)*t, cy + (ey-cy)*t, );
				
				
				
			}
		}
		
	/**************************
	 *		DRAWING APIS
	 *************************/
		
		public function clear():IDraw {
			g.clear();
			_drawingX = 0;
			_drawingY = 0;
			return this; 
		}
		
		public function endFill():IDraw {
			g.endFill();
			return this; 
		}
		
		public function lineTo(x:Number, y:Number):IDraw {
			(_dash == 0 && _space == 0) ? g.lineTo(x, y) : drawDashLine(_drawingX, _drawingY, x, y);
			_drawingX = x;
			_drawingY = y;
			return this;
		}
		
		public function moveTo(x:Number, y:Number):IDraw {
			g.moveTo(x, y);
			_drawingX = x;
			_drawingY = y;
			return this; 
		}
		
		public function copyFrom(sourceGraphics:Graphics):IDraw {
			g.copyFrom(sourceGraphics);
			return this;
		}
		
		public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):IDraw {
			g.curveTo(controlX, controlY, anchorX, anchorY);
			_drawingX = anchorX;
			_drawingY = anchorY;
			return this; 
		}
		
		public function drawCircle(x:Number, y:Number, radius:Number):IDraw {
			g.drawCircle(x, y, radius);
			//TODO : check drawing position
			return this; 
		}
		
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):IDraw	{
			g.drawEllipse(x, y, width, height);
			//TODO : check drawing position
			return this; 
		}
		
		public function drawGraphicsData(graphicsData:Vector.<IGraphicsData>):IDraw {
			g.drawGraphicsData(graphicsData);
			//TODO : check drawing position
			return this; 
		}
		
		public function drawPath(commands:Vector.<int>, data:Vector.<Number>, winding:String = "evenOdd"):IDraw {
			g.drawPath(commands, data, winding);
			//TODO : check drawing position
			return this; 
		}
		
		public function drawRect(x:Number, y:Number, width:Number, height:Number):IDraw {
			g.drawRect(x, y, width, height);
			//TODO : check drawing position
			return this; 
		}
		
		public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight: Number):IDraw {
			g.drawRoundRect(x, y, width, height, ellipseWidth, ellipseHeight);
			//TODO : check drawing position
			return this; 
		}
		
		public function drawRoundRectComplex(x:Number, y:Number, width:Number, height:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number):IDraw
		{
			g.drawRoundRectComplex(x, y, width, height, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius);
			//TODO : check drawing position
			return this; 
		}
		
		public function drawTriangles(vertices:Vector.<Number>, indices:Vector.<int> = null, uvtData:Vector.<Number> = null, culling:String = "none"):IDraw {
			g.drawTriangles(vertices, indices, uvtData, culling);
			//TODO : check drawing position
			return this; 
		}
		
	/**************************
	 *		FILL OPTIONS
	 *************************/
		
		public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):IDraw {
			g.beginBitmapFill(bitmap, matrix, repeat, smooth);
			return this; 
		}
		
		public function beginFill(color:uint, alpha:Number = 1):IDraw {
			g.beginFill(color, alpha);
			return this; 
		}
		
		public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):IDraw {
			g.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
			return this; 
		}
		
		public function beginShaderFill(shader:Shader, matrix:Matrix = null):IDraw {
			g.beginShaderFill(shader, matrix);
			return this; 
		}
		
	/**************************
	 *		LINE OPTIONS
	 *************************/	
		
		public function lineBitmapStyle(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):IDraw {
			g.lineBitmapStyle(bitmap, matrix, repeat, smooth);
			return this; 
		}
		
		public function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):IDraw {
			g.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
			return this; 
		}
		
		public function lineShaderStyle(shader:Shader, matrix:Matrix = null):IDraw {
			g.lineShaderStyle(shader, matrix);
			return this; 
		}
		
		public function lineStyle(thickness:Number = 1, color:uint = 0, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3, dash: Number = 0, space: Number = 0):IDraw	{
			g.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
			_dash	= dash;
			_space	= space;
			return this; 
		}
	}
}