package extendedhxpunk.ext;

import com.haxepunk.math.Vector;
import extendedhxpunk.ext.EXTConsole;

/**
 * EXTMath
 * Any mathematical function not covered by Math are contained here.
 * Created by Jams
 */
class EXTMath 
{
	public static inline var SQRT2:Float = 1.41421356237;
	public static inline var SQRT2_2:Float = 0.70710678119;
	
	public static function sgn(obj:Dynamic):Int
	{
		if (Std.is(obj, Int) || Std.is(obj, Float))
		{
			if (obj > 0)
				return 1;
			else if (obj < 0)
				return -1;
			else
				return 0;
		}
		else
		{
			EXTConsole.error("Error: Using Math function with a non-number type", "sgn()", []);
			return 1;
		}
	}
	
	public static function angleBetweenVectors(u:Vector, v:Vector):Float
	{
		return Math.acos(u.dot(v) / (Math.sqrt((u.x * u.x) + (u.y * u.y)) * Math.sqrt((v.x * v.x) + (v.y * v.y))));
	}
}
