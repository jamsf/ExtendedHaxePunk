package extendedhxpunk.ext;

import com.haxepunk.utils.Key;
	
/*
 * ExtendedKey
 * Extends the functionality of HaxePunk's Key class to cover more of the keyboard.
 * Created by Fletcher, 4/23/13, Ported by Jams, 11/7/13
 */
class EXTKey extends Key
{
	public static inline var BACKSLASH:Int = 220;
	public static inline var SLASH:Int = 191;
	public static inline var PERIOD:Int = 190;
	public static inline var COMMA:Int = 188;
	public static inline var QUOTE:Int = 222;
	public static inline var COLON:Int = 186;
	public static inline var EQUALS:Int = 187;
	public static inline var DASH:Int = 189;
	
	public static function name(char:Int):String
	{
		switch (char)
		{
			case BACKSLASH:
				return "BACKSLASH";
				
			case SLASH:
				return "SLASH";
				
			case PERIOD:
				return "PERIOD";
				
			case COMMA:
				return "COMMA";
				
			case QUOTE:
				return "QUOTE";
				
			case COLON:
				return "COLON";
				
			case EQUALS:
				return "EQUALS";
				
			case DASH:
				return "DASH";
				
			default:
				return Key.nameOfKey(char);
		}
	}
}