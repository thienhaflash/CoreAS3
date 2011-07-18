package vn.flash.display.shortcut 
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author thienhaflash
	 */
	public function scaleAround(target: Object, x: Number, y: Number, sx: Number, sy: Number, oMatrix: Matrix = null) : void
	{
		var m	: Matrix;
		/*
			Maple 14 syntax : evalm(`&*`(`&*`(Matrix(3, 3, {(1, 1) = 1, (1, 2) = 0, (1, 3) = x0, (2, 1) = 0, (2, 2) = 1, (2, 3) = y0, (3, 1) = 0, (3, 2) = 0, (3, 3) = 1}), Matrix(3, 3, {(1, 1) = sx, (1, 2) = 0, (1, 3) = 0, (2, 1) = 0, (2, 2) = sy, (2, 3) = 0, (3, 1) = 0, (3, 2) = 0, (3, 3) = 1})), Matrix(3, 3, {(1, 1) = 1, (1, 2) = 0, (1, 3) = -x0, (2, 1) = 0, (2, 2) = 1, (2, 3) = -y0, (3, 1) = 0, (3, 2) = 0, (3, 3) = 1})))
			
			|1	0	x|		|sx		0		0|		|1	0	-x|		|sx		0		x*(1-sx)|
			|0	1	y|	*	|1		sy		0|	*	|0	1	-y|	 =	|0		sy		y*(1-sy)|
			|0	0	1|      |0		0		1|      |0	0	1 |     |0		0		1		|
			
		*/
		if (oMatrix) {
			m = oMatrix.clone();
			m.concat(new Matrix(sx, 0, 0, sy, x*(1-sx), y*(1-sy)));
		} else {
			m = new Matrix(sx, 0, 0, sy, x*(1-sx), y*(1-sy));
		}
		(target as DisplayObject).transform.matrix = m;
	}
}