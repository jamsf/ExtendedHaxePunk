package extendedhxpunk.ext;

import flash.geom.Point;

/**
 * Hover Camera
 * Camera with added functionality to allow a hovering
 * 	animation around its target.
 * This function can be used to create a Float of effects,
 * 	static scene feel more lively.
 * @author Fletcher, 6/2/13, Ported by Jams, 11/7/13
 */
class EXTHoverCamera extends EXTCamera
{
	public function new() 
	{
		super();
		
		_hovering = false;
		_hoverTarget = new Point();
		_hoverVelocity = new Point();
		_maxHover = new Point();
		_hoverDistance = new Point();
		_hoverSpeed = 0.0;
		_hoverOffset = new Point();
	}
	
	// Set the camera to hover around its target point.
	//  variance - Maximum distance to stray
	//  speed - speed of movement
	public function enableHovering(xVariance:Float, yVariance: Float, speed:Float):Void
	{
		_hovering = true;
		_maxHover = new Point(xVariance, yVariance);
		_hoverSpeed = speed;
		_hoverOffset = new Point();
		_hoverDistance = new Point();
		_hoverVelocity = new Point();
		this.findHoverTarget();
	}
	
	public function disableHovering():Void
	{
		_hovering = false;
		_x -= _hoverOffset.x;
		_y -= _hoverOffset.y;
		_hoverOffset.x = 0;
		_hoverOffset.y = 0;
	}
	
	public var hovering(get, never):Bool;
	public function get_hovering():Bool { return _hovering; }
	
	// Overridden EXTCamera methods
	override public function update():Void
	{
		var oldX:Float = this.x;
		var oldY:Float = this.y;
		
		if (_hovering)
		{
			if (_lerping)
			{
				_hoverOffset.x = 0;
				_hoverOffset.y = 0;
			}
			else
			{
				_x -= _hoverOffset.x;
				_y -= _hoverOffset.y;
				oldX = _x;
				oldY = _y;
			}
		}
		
		super.update();
		
		if (_hovering)
		{
			if (_lerping)
			{
				_hoverTarget.x = _x;
				_hoverTarget.y = _y;
				_hoverDistance.x = 0;
				_hoverDistance.y = 0;
			}
			else
			{
				var hoverDistance:Point = _hoverTarget.subtract(_hoverOffset);
				var distanceMagnitude:Float = hoverDistance.length;
				var newTarget:Bool = false;
				
				//if (distanceMagnitude <= 2 * _hoverSpeed)
				if ((hoverDistance.x < 0 && _hoverDistance.x >= 0) ||
					(hoverDistance.x >= 0 && _hoverDistance.x < 0) ||
					(hoverDistance.y < 0 && _hoverDistance.y >= 0) ||
					(hoverDistance.y >= 0 && _hoverDistance.y < 0))
				{
					newTarget = true;
					this.findHoverTarget();
					
					hoverDistance = _hoverTarget.subtract(_hoverOffset);
					_hoverDistance.x = hoverDistance.x;
					_hoverDistance.y = hoverDistance.y;
					_hoverVelocity.x = 0;
					_hoverVelocity.y = 0;
				}
				
				var _hoverVelocityMagnitude:Float = _hoverVelocity.length;
				hoverDistance.normalize(1.0);
				
				if (!newTarget && distanceMagnitude <= _hoverDistance.length / 3.0)
				{
					if (_hoverVelocityMagnitude > _hoverSpeed)
					{
						_hoverVelocity.x -= hoverDistance.x * _hoverSpeed;
						_hoverVelocity.y -= hoverDistance.y * _hoverSpeed;
					}
					else
					{
						_hoverVelocity.x = hoverDistance.x * _hoverSpeed;
						_hoverVelocity.y = hoverDistance.y * _hoverSpeed;
					}
				}
				else
				{
					if (distanceMagnitude > _hoverDistance.length * 2.0 / 3.0)
					{
						var maxSpeed:Float = _hoverSpeed * 5;
						
						//if (_hoverVelocityMagnitude < maxSpeed)
						//{
						_hoverVelocity.x += hoverDistance.x * _hoverSpeed;
						_hoverVelocity.y += hoverDistance.y * _hoverSpeed;
						//}
						//else
						//{
							//_hoverVelocity.x = hoverDistance.x * _hoverSpeed;
							//_hoverVelocity.y = hoverDistance.y * _hoverSpeed;
						//}
					}
				}
				
				_hoverOffset.x += _hoverVelocity.x;
				_hoverOffset.y += _hoverVelocity.y;
				_x += _hoverOffset.x;
				_y += _hoverOffset.y;
			}
		}
	}
	
	
	//Protected
	private var _hovering:Bool;
	private var _hoverSpeed:Float;
	private var _maxHover:Point;
	private var _hoverOffset:Point;
	private var _hoverTarget:Point;
	private var _hoverVelocity:Point;
	private var _hoverDistance:Point;
	
	// Find a random point in an ellipse created by the hover variance
	private function findHoverTarget():Void
	{
		if (_maxHover.x == 0.0)
		{
			_hoverTarget.x = 0;
			_hoverTarget.y = Math.random() * _maxHover.y;
		}
		else if (_maxHover.y == 0.0)
		{
			_hoverTarget.x = Math.random() * _maxHover.x;
			_hoverTarget.y = 0;
		}
		else
		{
			var randomAngle:Float = Math.random() * 360.0;
			var randomRoot:Float = Math.sqrt(Math.random() * 1.0);
			_hoverTarget.x = Math.cos(randomAngle) * randomRoot * _maxHover.x / 2.0;
			_hoverTarget.y = Math.sin(randomAngle) * randomRoot * _maxHover.y / 2.0;
		}
	}
}