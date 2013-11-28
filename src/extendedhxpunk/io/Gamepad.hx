package extendedhxpunk.io;

import com.haxepunk.utils.Joystick;
import haxe.io.Error;
import openfl.events.JoystickEvent;

enum XboxButton
{
	A_BUTTON,
	B_BUTTON,
	X_BUTTON,
	Y_BUTTON,
	LB_BUTTON,
	RB_BUTTON,
	LEFT_ANALOGUE_BUTTON,
	RIGHT_ANALOGUE_BUTTON,
	BACK_BUTTON,
	START_BUTTON,
	DPAD_LEFT_BUTTON,
	DPAD_RIGHT_BUTTON,
	DPAD_DOWN_BUTTON,
	DPAD_UP_BUTTON
}

/**
 * Joystick with added functions for accessing controller values easier
 * @author Jams
 */
class Gamepad
{

	public function new(joystick:Joystick)
	{
		super()
		_joystick = joystick;
	}
	
	//----------------------------------| BUTTONS |----------------------------------//
	
	public function pressed(XboxButton button):Bool
	{
		switch(button)
		{
			A_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.A_BUTTON);
			B_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.B_BUTTON);
			X_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.X_BUTTON);
			Y_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.Y_BUTTON);
			LB_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.LB_BUTTON);
			RB_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.RB_BUTTON);
			START_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.START_BUTTON);
			BACK_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.BACK_BUTTON);
			RIGHT_ANALOGUE_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.RIGHT_ANALOGUE_BUTTON);
			LEFT_ANALOGUE_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.LEFT_ANALOGUE_BUTTON);
			DPAD_DOWN_BUTTON:
				return _joystick.hat.y > 0;
			DPAD_LEFT_BUTTON:
				return _joystick.hat.x < 0;
			DPAD_RIGHT_BUTTON:
				return _joystick.hat.x > 0;
			DPAD_UP_BUTTON:
				return _joystick.hat.y < 0;
			default:
				return false;
		}
	}
	
	public function pressed(XboxButton button):Bool
	{
		switch(button)
		{
			A_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.A_BUTTON);
			B_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.B_BUTTON);
			X_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.X_BUTTON);
			Y_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.Y_BUTTON);
			LB_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.LB_BUTTON);
			RB_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.RB_BUTTON);
			START_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.START_BUTTON);
			BACK_BUTTON:
				return _joystick.pressed(XBOX_GAMEPAD.BACK_BUTTON);
			DPAD_DOWN_BUTTON:
				return _joystick.hat.y > 0;
			DPAD_LEFT_BUTTON:
				return _joystick.hat.x < 0;
			DPAD_RIGHT_BUTTON:
				return _joystick.hat.x > 0;
			DPAD_UP_BUTTON:
				return _joystick.hat.y < 0;
			default:
				return false;
		}
	}
	
	//----------------------------------| ANALOGUE STICKS |----------------------------------//
	
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
		if (getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_X) < Joystick.deadZone && getAxis(XBOX_GAMEPAD.RIGHT_ANALOGUE_Y) > Joystick.deadZone)
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
		if (getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_X) < Joystick.deadZone && getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_X) > Joystick.deadZone)
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
		return Math.abs(Math.min(0, _joystick.getAxis(XBOX_GAMEPAD.TRIGGER)));
	}
	
	/**
	 * Gets distance of right trigger
	 * @return right trigger distance, between 0 and 1
	 */
	public var leftTriggerDistance(get, never):Float;
	public function get_leftTriggerDistance():Float
	{
		return Math.max(0, _joystick.getAxis(XBOX_GAMEPAD.TRIGGER));
	}
	
	private var _joystick : Joystick;
}