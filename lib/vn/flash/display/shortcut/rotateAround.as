package vn.flash.display.shortcut 
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function rotateAround(target: Object, x: Number, y: Number, angle: Number, oMatrix: Matrix = null): void 
	{
		angle *= Math.PI / 180;
		var sin : Number = Math.sin(angle);
		var cos : Number = Math.cos(angle);
		var m	: Matrix;
		
		/*
			Maple 14 syntax : evalm(`&*`(`&*`(Matrix(3, 3, {(1, 1) = 1, (1, 2) = 0, (1, 3) = x0, (2, 1) = 0, (2, 2) = 1, (2, 3) = y0, (3, 1) = 0, (3, 2) = 0, (3, 3) = 1}), Matrix(3, 3, {(1, 1) = cos, (1, 2) = -sin, (1, 3) = 0, (2, 1) = sin, (2, 2) = cos, (2, 3) = 0, (3, 1) = 0, (3, 2) = 0, (3, 3) = 1})), Matrix(3, 3, {(1, 1) = 1, (1, 2) = 0, (1, 3) = -x0, (2, 1) = 0, (2, 2) = 1, (2, 3) = -y0, (3, 1) = 0, (3, 2) = 0, (3, 3) = 1})))
			
			|1	0	x|		|cos	-sin	0|		|1	0	-x|		|cos	-sin	-cos*x+sin*y+x	|
			|0	1	y|	*	|sin	cos		0|	*	|0	1	-y|	 =	|sin	cos		-sin*x-cos*y+y	|
			|0	0	1|      |0		0		1|      |0	0	1 |     |0		0		1				|
			
		*/
		
		if (oMatrix) {
			m = oMatrix.clone();
			m.concat(new Matrix(cos, sin, -sin, cos, -cos * x + sin * y + x, -sin * x - cos * y + y));
		} else {
			m = new Matrix(cos, sin, -sin, cos, -cos * x + sin * y + x, -sin * x - cos * y + y);
		}
		(target as DisplayObject).transform.matrix = m;
	}
}