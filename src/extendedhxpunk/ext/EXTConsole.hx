package extendedhxpunk.ext;

#if debug
	import com.haxepunk.HXP;
	import com.haxepunk.utils.Input;
#end
	
/**
 * ExtendedConsole
 * Static class which handles different types of logging, 
 *   and displaying of debug console
 * Created by Fletcher, 4/23/13, Ported by Jams, 11/6/13
 */
class EXTConsole
{
#if debug
	public static inline var CONSOLE_KEY:Int = EXTKey.BACKSLASH;
#end
	/**
	 * Logging function for when a serious error occurs, often to be logged on 
	 *   a release build when a debug build should crash.  Also forces console
	 *   to display if on a debug build.
	 * @param	filename		Filename of location of log statement
	 * @param	functionName	Function name of location of log statement
	 * @param	...data			Formatted string to log
	 */
	public static function error(filename:String, functionName:String, data:Array<Dynamic>):Void
	{
		var errorStringPrefix:String = "ERROR: " + "[" + filename + "." + functionName + "]";
	#if debug
			HXP.console.visible = true;
			HXP.console.log([errorStringPrefix, data]);
	#end
		trace(errorStringPrefix, data);
	}
	
	/**
	 * Logging function to be used when there might be something wrong,
	 *   should be used sparingly as it will be traced on both debug 
	 *   and release builds
	 * @param	filename		Filename of location of log statement
	 * @param	functionName	Function name of location of log statement
	 * @param	...data			Formatted string to log
	 */
	public static function warn(filename:String, functionName:String, data:Array<Dynamic>):Void
	{
		var infoStringPrefix:String = "WARN: " + "[" + filename + "." + functionName + "]";
	#if debug
			HXP.console.log([infoStringPrefix, data]);
	#end
		trace(infoStringPrefix, data);
	}
	
	/**
	 * Logging function which provides information, should be used sparingly as 
	 *   it will be traced on both debug and release builds
	 * @param	filename		Filename of location of log statement
	 * @param	functionName	Function name of location of log statement
	 * @param	...data			Formatted string to log
	 */
	public static function info(filename:String, functionName:String, data:Array<Dynamic>):Void
	{
		var infoStringPrefix:String = "INFO: " + "[" + filename + "." + functionName + "]";
	#if debug
		HXP.console.log([infoStringPrefix, data]);
	#end
		trace(infoStringPrefix, data);
	}
	
	/**
	 * Logging function which can be used anywhere we wish to provide additional
	 *   info which will help debug during development; won't be traced on release.
	 * @param	filename		Filename of location of log statement
	 * @param	functionName	Function name of location of log statement
	 * @param	...data			Formatted string to log
	 */
	public static function debug(filename:String, functionName:String, data:Array<Dynamic>):Void
	{
	#if debug
		var debugStringPrefix:String = "DEBUG: " + "[" + filename + "." + functionName + "]";
		HXP.console.log([debugStringPrefix, data]);
		trace(debugStringPrefix, data);
	#end
	}
	
	/**
	 * Call at start of program to initialize the console
	 */
	public static function initializeConsole():Void
	{
	#if debug
		HXP.console.enable();
		EXTConsole.debug("EXTConsole", "initializeConsole()", ["EXTConsole Initialized"]);
	#end
	}
	
#if debug
	/**
	 * Call in your update loop on debug builds to allow toggling of console visualizer
	 */
	public static function update():Void
	{
		if (Input.pressed(CONSOLE_KEY))
		{
			HXP.console.visible = !HXP.console.visible;
		}
	}
#end
}