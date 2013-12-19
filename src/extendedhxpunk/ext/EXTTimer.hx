package extendedhxpunk.ext;

import com.haxepunk.Entity;
import com.haxepunk.HXP;

/**
 * EXTTimer
 * Receive a callback after a given amount of time in-game
 * Created by Fletcher, 12/18/2013
 */
class EXTTimer extends Entity
{
	public var loop:Bool;
	public var paused:Bool;
	
	/**
	 * Create a new timer, to call "callbackFunction" after the given time has passed.
	 * The new timer will automatically be added to the current world, and if looping is 
	 * disabled, it will remove itself when it is finished (otherwise you must call invalidate).
	 * @param	durationInSeconds	Time in seconds before callback is called.
	 * @param	loop				Whether to loop the timer indefinitely.
	 * @param	callbackFunction	Function to call when timer reaches its end.
	 */
	public static function createTimer(durationInSeconds:Float, loop:Bool, callbackFunction:EXTTimer->Void):EXTTimer
	{
		var timer:EXTTimer = new EXTTimer(durationInSeconds, loop, callbackFunction);
		HXP.scene.add(timer);
		return timer;
	}
	
	public function reset():Void
	{
		_timeSoFarInSeconds = 0.0;
	}
	
	public function invalidate():Void
	{
		_valid = false;
		HXP.scene.remove(this);
	}
	
	override public function update():Void
	{
		if (_valid && !this.paused)
		{
			_timeSoFarInSeconds += HXP.elapsed;
			if (_timeSoFarInSeconds >= _durationInSeconds)
			{
				_callbackFunction(this);
				
				if (this.loop)
					_timeSoFarInSeconds -= _durationInSeconds;
				else
					this.invalidate();
			}
		}
	}
	
	/**
	 * Private
	 */
	private var _valid:Bool = true;
	private var _timeSoFarInSeconds:Float = 0.0;
	private var _durationInSeconds:Float;
	private var _callbackFunction:EXTTimer->Void;
	
	private function new(durationInSeconds:Float, loop:Bool, callbackFunction:EXTTimer->Void) 
	{
		super();
		
		_callbackFunction = callbackFunction;
		_durationInSeconds = durationInSeconds;
		this.loop = loop;
		this.paused = false;
	}
}
