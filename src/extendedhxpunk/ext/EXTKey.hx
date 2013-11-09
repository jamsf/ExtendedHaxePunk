package extendedhxpunk.ext;

import com.haxepunk.utils.Key;
	
	// ExtendedKey
	// Extends the functionality of Flashpunk's Key class to cover
	//   more of the keyboard.
	// Created by Fletcher, 4/23/13, Ported by Jams, 11/7/13
	public class EXTKey extends Key
	{
		public static const TILDE:int = 192;
		public static const BACKSLASH:int = 220;
		public static const SLASH:int = 191;
		public static const PERIOD:int = 190;
		public static const COMMA:int = 188;
		public static const QUOTE:int = 222;
		public static const COLON:int = 186;
		public static const EQUALS:int = 187;
		public static const DASH:int = 189;
		
		public static function name(char:int):String
		{
			switch (char)
			{
				case TILDE:
					return "TILDE";
					
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
					return "DASH";;
					
				default:
					return Key.name(char);
			}
		}
	}