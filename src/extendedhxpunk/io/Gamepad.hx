package extendedhxpunk.io;

import com.haxepunk.utils.Joystick;
import com.haxepunk.utils.Input;
import haxe.io.Error;
import openfl.events.JoystickEvent;

enum XboxButton
{
	A_BUTTON;
	B_BUTTON;
	X_BUTTON;
	Y_BUTTON;
	LB_BUTTON;
	RB_BUTTON;
	LEFT_ANALOGUE_BUTTON;
	RIGHT_ANALOGUE_BUTTON;
	BACK_BUTTON;
	START_BUTTON;
	DPAD_LEFT_BUTTON;
	DPAD_RIGHT_BUTTON;
	DPAD_DOWN_BUTTON;
	DPAD_UP_BUTTON;
}

/**
 * Joystick with added functions for accessing controller values easier
 * @author Jams
 */
class Gamepad
{
	public function new(gamepadId:Int)
	{
		_joystick = Input.joystick(gamepadId);
	}
	
	//----------------------------------| BUTTONS |----------------------------------//
	
	public function pressed(button:XboxButton):Bool
	{
		switch(button)
		{
			case A_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.A_BUTTON);
			case B_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.B_BUTTON);
			case X_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.X_BUTTON);
			case Y_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.Y_BUTTON);
			case LB_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.LB_BUTTON);
			case RB_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.RB_BUTTON);
			case START_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.START_BUTTON);
			case BACK_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.BACK_BUTTON);
			case RIGHT_ANALOGUE_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.RIGHT_ANALOGUE_BUTTON);
			case LEFT_ANALOGUE_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.LEFT_ANALOGUE_BUTTON);
			case DPAD_DOWN_BUTTON:
				return _joystick.hat.y > 0;
			case DPAD_LEFT_BUTTON:
				return _joystick.hat.x < 0;
			case DPAD_RIGHT_BUTTON:
				return _joystick.hat.x > 0;
			case DPAD_UP_BUTTON:
				return _joystick.hat.y < 0;
		}
	}
	
	public function check(button:XboxButton):Bool
	{
		switch(button)
		{
			case A_BUTTON:
				return _joystick.check(XBOX_GAMEPAD.A_BUTTON);
			case B_BUTTON:
				return _joystick.check(XBOX_GAMEPAD.B_BUTTON);
			case X_BUTTON:
				return _joystick.check(XBOX_GAMEPAD.X_BUTTON);
			case Y_BUTTON:
				return _joystick.check(XBOX_GAMEPAD.Y_BUTTON);
			case LB_BUTTON:
				return _joystick.check(XBOX_GAMEPAD.LB_BUTTON);
			case RB_BUTTON:
				return _joystick.check(XBOX_GAMEPAD.RB_BUTTON);
			case START_BUTTON:
				return _joystick.check(XBOX_GAMEPAD.START_BUTTON);
			case BACK_BUTTON:
				return _joystick.check(XBOX_GAMEPAD.BACK_BUTTON);
			case RIGHT_ANALOGUE_BUTTON:
				return _joystick.check(XBOX_GAMEPAD.RIGHT_ANALOGUE_BUTTON);
			case LEFT_ANALOGUE_BUTTON:
				return _joystick.check(XBOX_GAMEPAD.LEFT_ANALOGUE_BUTTON);
			case DPAD_DOWN_BUTTON:
				return _joystick.hat.y > 0;
			case DPAD_LEFT_BUTTON:
				return _joystick.hat.x < 0;
			case DPAD_RIGHT_BUTTON:
				return _joystick.hat.x > 0;
			case DPAD_UP_BUTTON:
				return _joystick.hat.y < 0;
		}
	}
	
	//----------------------------------| ANALOGUE STICKS |----------------------------------//
	
	public var rightAnalogueX(get, never):Float;
	public function get_rightAnalogueX():Float { return _joystick.getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_X); }
	public var rightAnalogueY(get, never):Float;
	public function get_rightAnalogueY():Float { return _joystick.getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y); }
	public var leftAnalogueX(get, never):Float;
	public function get_leftAnalogueX():Float { return _joystick.getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_X); }
	public var leftAnalogueY(get, never):Float;
	public function get_leftAnalogueY():Float { return _joystick.getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y); }
	
	/**
	 * Gets angle of right analogue stick
	 * @return right analogue stick angle in radians
	 */
	public var rightStickAngle(get, never):Float;
	public function get_rightStickAngle():Float
	{
		return Math.atan2(_joystick.getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_X), _joystick.getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y));
	}

	/**
	 * Gets angle of left analogue stick
	 * @return left analogue stick angle in radians
	 */
	public var leftStickAngle(get, never):Float;
	public function get_leftStickAngle():Float
	{
		return Math.atan2(_joystick.getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_X), _joystick.getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y));
	}
	
	/**
	 * Gets distance of right analogue stick
	 * @return right analogue stick distance, between 0 and 1
	 */
	public var rightStickDistance(get, never):Float;
	public function get_rightStickDistance():Float
	{
		if (_joystick.getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_X) < Joystick.deadZone && _joystick.getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y) > Joystick.deadZone)
			return 0;
		return Math.sqrt( Math.pow(_joystick.getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_X), 2) + Math.pow(_joystick.getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_X), 2) );
	}
	
	/**
	 * Gets distance of left analogue stick
	 * @return left analogue stick distance, between 0 and 1
	 */
	public var leftStickDistance(get, never):Float;
	public function get_leftStickDistance():Float
	{
		if (_joystick.getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_X) < Joystick.deadZone && _joystick.getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_X) > Joystick.deadZone)
			return 0;
		return Math.sqrt( Math.pow(_joystick.getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_X), 2) + Math.pow(_joystick.getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_X), 2) );
	}
	
	//----------------------------------| TRIGGERS |----------------------------------//
	
	/**
	 * Gets distance of right trigger
	 * @return right trigger distance, between 0 and 1
	 */
	public var rightTriggerDistance(get, never):Float;
	public function get_rightTriggerDistance():Float
	{
#if mac
		//TODO - fcole - How does xbox trigger work on mac?
		return 0.0;
#else
		return Math.abs(Math.min(0, _joystick.getAxis(XBOX_GAMEPAD.TRIGGER)));
#end
	}
	
	/**
	 * Gets distance of right trigger
	 * @return right trigger distance, between 0 and 1
	 */
	public var leftTriggerDistance(get, never):Float;
	public function get_leftTriggerDistance():Float
	{
#if mac
		//TODO - fcole - How does xbox trigger work on mac?
		return 0.0;
#else
		return Math.max(0, _joystick.getAxis(XBOX_GAMEPAD.TRIGGER));
#end
	}
	
	private var _joystick : Joystick;
}