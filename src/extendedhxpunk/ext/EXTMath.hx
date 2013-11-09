package extendedhxpunk.ext;

import extendedhxpunk.ext.EXTConsole;

/**
 * Any mathematical function not covered by Math are contained here.
 * @author Jams
 */
class EXTMath 
{
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
}