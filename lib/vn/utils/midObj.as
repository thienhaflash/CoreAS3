package vn.utils
{
	/**
	 * @version 0.1.0
	 * @author thienhaflash (thienhaflash@gmail.com)
	 * @update 26 April 2010 (0.1.0)
	 */
	
	/**
	 * linear interpolate property values from two objects and apply to a target
	 * @param	start the start object (percent = 0)
	 * @param	end the end object (percent = 1)
	 * @param	percent the interpolation percentage
	 * @param	obj the object to be applied 
	 * @return
	 */
	public function midObj(obj : Object, percent: Number, start: Object, end:Object) : Object
	{
		var delta 	: Number = 0;
		for (var s: String in end) {
			delta = end[s] - start[s];
			obj[s] = start[s] + delta * percent;
		}
		return obj;
	}
}