package vn.core.flash 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class Math2
	{
		public static function getCurveLength(sx: Number, sy: Number, cx: Number, cy: Number, ex: Number, ey: Number): Number {
			var ax:Number = sx - 2*cx + ex;  
            var ay:Number = sy - 2*cy + ey;  
            var bx:Number = 2 * cx - 2 * sx;  
            var by:Number = 2 * cy - 2 * sy; 
			
			var a:Number = 4 * (ax * ax + ay * ay);  
            var b:Number = 4 * (ax * bx + ay * by);  
            var c:Number = bx * bx + by * by; 
			
			var abc:Number = 2 * Math.sqrt(a + b + c);  
            var a2:Number  = Math.sqrt(a);  
            var a32:Number = 2 * a * a2;  
            var c2:Number  = 2 * Math.sqrt(c);  
            var ba:Number  = b / a2;
			
			return (a32 * abc + a2 * b * (abc - c2) + (4 * c * a - b * b) * Math.log((2 * a2 + ba + abc) / (ba + c2))) / (4 * a32);
		}
		
		function intersection(p1:Point, p2:Point, p3:Point, p4:Point):Point {
var x1:Number = p1.x, x2:Number = p2.x, x3:Number = p3.x, x4:Number = p4.x;
var y1:Number = p1.y, y2:Number = p2.y, y3:Number = p3.y, y4:Number = p4.y;
var z1:Number= (x1 -x2), z2:Number = (x3 - x4), z3:Number = (y1 - y2), z4:Number = (y3 - y4);
var d:Number = z1 * z4 - z3 * z2;
 
// If d is zero, there is no intersection
if (d == 0) return null;
 
// Get the x and y
var pre:Number = (x1*y2 - y1*x2), post:Number = (x3*y4 - y3*x4);
var x:Number = ( pre * z2 - z1 * post ) / d;
var y:Number = ( pre * z4 - z3 * post ) / d;
 
// Check if the x and y coordinates are within both lines
if ( x < Math.min(x1, x2) || x > Math.max(x1, x2) ||
x < Math.min(x3, x4) || x > Math.max(x3, x4) ) return null;
if ( y < Math.min(y1, y2) || y > Math.max(y1, y2) ||
y < Math.min(y3, y4) || y > Math.max(y3, y4) ) return null;
 
// Return the point of intersection
return new Point(x, y);
}
		
		
		public static function getLineSegmentIntersect(A:Point, B:Point, C:Point, D:Point): Point {
			
			
			
			var ip:Point;
			var a1:Number = B.y - A.y;
			var a2:Number = D.y - C.y;
			var b1:Number = A.x - B.x;
			var b2:Number = C.x - D.x;
			var c1:Number = B.x * A.y - A.x * B.y;
			var c2:Number = D.x * C.y - C.x * D.y;
			
			var denom:Number = a1 * b2 - a2 * b1;
			if (denom == 0) return null; //parallel case
			
			ip = new Point((b1 * c2 - b2 * c1) / denom, (a2 * c1 - a1 * c2) / denom);
			
			if ( //outter intersection :: TODO : optimize !
				(Math.pow(ip.x - B.x, 2) + Math.pow(ip.y - B.y, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.y - B.y, 2)) ||
				(Math.pow(ip.x - A.x, 2) + Math.pow(ip.y - A.y, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.y - B.y, 2)) ||
				(Math.pow(ip.x - D.x, 2) + Math.pow(ip.y - D.y, 2) > Math.pow(C.x - D.x, 2) + Math.pow(C.y - D.y, 2)) ||
				(Math.pow(ip.x - C.x, 2) + Math.pow(ip.y - C.y, 2) > Math.pow(C.x - D.x, 2) + Math.pow(C.y - D.y, 2))
			) return null;
			
			return ip;
		}
	}

}