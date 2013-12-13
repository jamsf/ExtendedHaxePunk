package extendedhxpunk.ext;

/**
 * EXTColor
 * Class which wraps color value handling in a simple interface
 *    and provides convenience functions.
 * Created by Fletcher, 10/6/13, Ported by Jams, 11/6/13
 */
class EXTColor 
{
	public function new()
	{
		webColor = 0;
		alpha = 0;
	}
	
	// Hex RGB value, i.e. 0xFF0000 is full red
	public var webColor:UInt;
	
	// Alpha value, 0 to 1
	public var alpha:Float;
	
	// Specific RGB values, 0 to 1
	public var red (get, set):Float;
	public function get_red():Float { return ((webColor & 0xFF0000) >> 16) / 255; }
	public function set_red(value:Float):Float { return this.setColor(value, this.green, this.blue, this.alpha); }
	
	public var green (get, set):Float;
	public function get_green():Float { return ((webColor & 0x00FF00) >> 8) / 255; }
	public function set_green(value:Float):Float { return this.setColor(this.red, value, this.blue, this.alpha); }
	
	public var blue (get, set):Float;
	public function get_blue():Float { return (webColor & 0x0000FF) / 255; }
	public function set_blue(value:Float):Float { return this.setColor(this.red, this.green, value, this.alpha); }
	
	// Set all color values, 0 to 1
	public function setColor(r:Float, g:Float, b:Float, a:Float):Float
	{
		var newColor:UInt = 0x000000;
		newColor += Std.int(r * 255);
		newColor = newColor << 8;
		newColor += Std.int(g * 255);
		newColor = newColor << 8;
		newColor += Std.int(b * 255);
		webColor = newColor;
		alpha = a;
		return cast(newColor, Float);
	}
}