package extendedhxpunk.ext;

import flash.geom.Point;
import com.haxepunk.HXP;
import extendedhxpunk.ext.EXTConsole;
import extendedhxpunk.ext.EXTOffsetType;
import extendedhxpunk.ext.EXTUtility;

/**
 * Extended Camera
 * Handles transformations to be made to the world before rendering
 * @author Fletcher, Ported by Jams
 */
class EXTCamera
{
	/**
	 * Public Accessors
	 * x and y represent pixel coordinates in the world when zoom is at 1.0
	 */
	public var x (get, never):Float;
	public function get_x():Float { return _x; };		// Position (upper-left)
	public var y (get, never):Float;
	public function get_y():Float { return _y; };
	public var vx (get, never):Float;
	public function get_vx():Float { return _vx; }; 	// Velocity
	public var vy (get, never):Float;
	public function get_vy():Float { return _vy; };
	public var ax (get, never):Float;
	public function get_ax():Float { return _ax; }; 	// Acceleration
	public var ay (get, never):Float;
	public function get_ay():Float { return _ay; };
	public var zoom (get, never):Float;
	public function get_zoom():Float { return _zoom; }; // Zoom
	public var zoomVelocity (get, never):Float;
	public function get_zoomVelocity():Float { return _zoomVelocity; };
	public var zoomAcceleration (get, never):Float;
	public function get_zoomAcceleration():Float { return _zoomAcceleration; };
	
	/**
	 * Constructor
	 */
	public function new()
	{
		_lastFrameX = _lastFrameY = 0.0;
		_lerping = false;
		_lerpStartPosition = new Point();
		_lerpDestination = new Point();
		_lerpTotalDistance = 0.0;
	}
	
	/**
	 * @return	The current size of the view, given the camera's 
	 *    current zoom value and the size of the screen.
	 */
	public function currentViewSize():Point
	{
		return new Point(HXP.screen.width / _zoom, HXP.screen.height / _zoom);
	}
	
	/**
	 * Get the current position of the camera
	 * @param	offsetType				Specifies which alignment of the camera to use
	 * @param	useLastFramePosition	Whether to use coordinates from the end of the last tick
	 */
	public function currentPosition(offsetType:EXTOffsetType, useLastFramePosition:Bool = false):Point
	{
		var screenSize:Point = this.currentViewSize();
		var baseX:Float = (useLastFramePosition ? _lastFrameX : _x);
		var baseY:Float = (useLastFramePosition ? _lastFrameY : _y);
		
		if (offsetType == EXTOffsetType.TOP_LEFT)
			return new Point(baseX, baseY);
		if (offsetType == EXTOffsetType.TOP_RIGHT)
			return new Point(baseX + screenSize.x, baseY);
		if (offsetType == EXTOffsetType.BOTTOM_LEFT)
			return new Point(baseX, baseY + screenSize.y);
		if (offsetType == EXTOffsetType.BOTTOM_RIGHT)
			return new Point(baseX + screenSize.x, baseY + screenSize.y);
		if (offsetType == EXTOffsetType.CENTER)
			return new Point(baseX + screenSize.x / 2, baseY + screenSize.y / 2);
		if (offsetType == EXTOffsetType.TOP_CENTER)
			return new Point(baseX + screenSize.x / 2, baseY);
		if (offsetType == EXTOffsetType.BOTTOM_CENTER)
			return new Point(baseX + screenSize.x / 2, baseY + screenSize.y);
		if (offsetType == EXTOffsetType.LEFT_CENTER)
			return new Point(baseX, baseY + screenSize.y / 2);
		if (offsetType == EXTOffsetType.RIGHT_CENTER)
			return new Point(baseX + screenSize.x, baseY + screenSize.y / 2);
		
		EXTConsole.error("EXTCamera", "currentPosition()", ["Invalid offset found: %s", Std.string(offsetType)]);
		return new Point();
	}
	
	/**
	 * Set the position of the camera
	 * @param	offsetType	How the camera's view frame should align with the given position
	 * @param	newPoint	The coordinates to align the camera with
	 */
	public function setCurrentPosition(offsetType:EXTOffsetType, newPosition:Point):Void
	{
		var screenSize:Point = this.currentViewSize();
		newPosition = EXTUtility.UpperLeftifyCoordinate(newPosition, screenSize, offsetType);
		_x = newPosition.x;
		_y = newPosition.y;
	}
	
	/**
	 * Move the camera a given amount
	 * @param	dx	Offset to move camera by along x-axis
	 * @param	dy	Offste to move camera by along y-axis
	 */
	public function moveDistance(dx:Float, dy:Float):Void
	{
		if (_lerping && _lerpDestination != null)
		{
			_lerpDestination.x += dx;
			_lerpDestination.y += dy;
		}
		_x += dx;
		_y += dy;
	}
	
	/**
	 * Change the camera's velocity
	 * @param	dvx	Offset to apply to x velocity
	 * @param	dvy	Offset to apply to y velocity
	 */
	public function alterVelocity(dvx:Float, dvy:Float):Void
	{
		if (!_lerping)
		{
			_vx += dvx;
			_vy += dvy;
		}
	}
	
	/**
	 * Change the camera's acceleration
	 * @param	fx	Force to apply to camera along x-axis, in pixels per second per second
	 * @param	fy	Force to apply to camera along y-axis, in pixels per second per second
	 */
	public function applyForce(fx:Float, fy:Float):Void
	{
		if (!_lerping)
		{
			_ax += fx;
			_ay += fy;
		}
	}
	
	/**
	 * Modify the zoom level of the camera while anchoring at a specific location.
	 *    (Editing the zoom attribute directly will zoom from the upper-left corner).
	 * @param	zoomDelta				The amount to change the zoom by
	 * @param	anchorPoint				The point to anchor the zoom at
	 * @param	measureFromOffsetType	Where the anchor point is measured from, within the camera's view
	 */
	public function zoomWithAnchor(zoomDelta:Float, anchorPoint:Point, measureFromOffsetType:EXTOffsetType):Void
	{
		if (_lerping)
		{
			EXTConsole.debug("EXTCamera", "zoomWithAnchor()", ["Cannot zoom while lerping"]);
			return;
		}
		
		var currentSize:Point = this.currentViewSize();
		var fromUpperLeft:Point = EXTUtility.UpperLeftifyCoordinate(anchorPoint, currentSize, measureFromOffsetType);
		var xProportion:Float = fromUpperLeft.x / currentSize.x;
		var yProportion:Float = fromUpperLeft.y / currentSize.y;
		
		_zoom += zoomDelta;
		
		var newSize:Point = this.currentViewSize();
		var newXWithProportion:Float = xProportion * newSize.x;
		var newYWithProportion:Float = yProportion * newSize.y;
		
		var xDiff:Float = newXWithProportion - fromUpperLeft.x;
		var yDiff:Float = newYWithProportion - fromUpperLeft.y;
		
		this.moveDistance(xDiff, yDiff);
		_lerpDestination.x += xDiff;
		_lerpDestination.y += yDiff;
	}
	
	/**
	 * Camera will smoothly animate to given position.
	 * @param	px	Target upper-left x position for camera
	 * @param	py	Target upper-left y position for camera
	 */
	//TODO - fcole - Allow input of various lerping functions
	public function lerpToPosition(px:Float, py:Float):Void
	{
		var oldStartPosition:Point = _lerpStartPosition;
		
		_ax = 0;
		_ay = 0;
		
		_lerpStartPosition.x = _x;
		_lerpStartPosition.y = _y;
		_lerpDestination.x = px;
		_lerpDestination.y = py;
		
		var diffX:Float = px - _lerpStartPosition.x;
		var diffY:Float = py - _lerpStartPosition.y;
		_lerpTotalDistance = Math.sqrt((diffX * diffX) + (diffY * diffY));
		
		if (_lerping)
		{
			var oldVMagnitude:Float = Math.sqrt((vx * vx) + (vy * vy));
			var xProportion:Float = diffX / _lerpTotalDistance;
			var yProportion:Float = diffY / _lerpTotalDistance;
			
			diffX = _lerpStartPosition.x - oldStartPosition.x;
			diffY = _lerpStartPosition.y - oldStartPosition.y;
			var oldDistance:Float = Math.sqrt((diffX * diffX) + (diffY * diffY));
			
			_vx = xProportion * oldVMagnitude;
			_vy = yProportion * oldVMagnitude;
			
			_lerpTotalDistance += oldDistance;
		}
		
		_lerping = true;
	}
	
	/**
	 * More useful lerping method.
	 * @param	px			X location, in screen coordinates, which camera should lerp to
	 * @param	py			Y location, in screen coordinates, which camera should lerp to
	 * @param	offsetType	How the camera should align with the given location (defaults to CENTER)
	 */
	public function lerpToCameraRelativePosition(px:Float, py:Float, offsetType:EXTOffsetType = null):Void
	{
		// Assume we normally want the camera to center on the specified point
		if (offsetType == null)
			offsetType = EXTOffsetType.CENTER;
		
		px /= _zoom;
		py /= _zoom;
		var startingPoint:Point = this.currentPosition(EXTOffsetType.TOP_LEFT, true);
		var destination:Point = new Point(startingPoint.x + px, startingPoint.y + py);
		var screenSize:Point = this.currentViewSize();
		var distance:Point = EXTUtility.DistanceBetweenTwoContainers(startingPoint,
																	 destination, 
																	 screenSize,
																	 screenSize, 
																	 EXTOffsetType.TOP_LEFT, 
																	 offsetType);
		this.lerpToPosition(startingPoint.x + distance.x, 
							startingPoint.y + distance.y);
	}
	
	/**
	 * Update the camera's world offsets
	 */
	public function update():Void
	{
		if (_lerping)
			this.updateLerping();
		
		_vx += _ax;
		_vy += _ay;
		_x += _vx;
		_y += _vy;
		
		if (!_lerping)
		{
			_zoomVelocity += _zoomAcceleration;
			_zoom += _zoomVelocity;
		}
		
		_lastFrameX = _x;
		_lastFrameY = _y;
	}
	
	
	/**
	 * private
	 */
	private var _x:Float = 0;      // Position (upper-left)
	private var _y:Float = 0;
	private var _vx:Float = 0;     // Velocity
	private var _vy:Float = 0;
	private var _ax:Float = 0;  	  // Acceleration
	private var _ay:Float = 0;
	private var _zoom:Float = 1.0; // Zoom
	private var _zoomVelocity:Float = 0;
	private var _zoomAcceleration:Float = 0;
	
	private var _lastFrameX:Float;
	private var _lastFrameY:Float;
	
	/**
	 * Lerping implementation
	 */
	private static inline var _LERP_SPEED_:Float = 0.1;
	private var _lerping:Bool;
	private var _lerpStartPosition:Point;
	private var _lerpDestination:Point;
	private var _lerpTotalDistance:Float;
	
	//TODO - fcole - Allow input of various lerping functions
	private function updateLerping():Void
	{
		var diffX:Float = _lerpDestination.x - _x;
		var diffY:Float = _lerpDestination.y - _y;
		var distance:Float = Math.sqrt((diffX * diffX) + (diffY * diffY));
		var reachedDestination:Bool = true;
		
		if (distance > 0.5)
		{
			reachedDestination = false;
			var xProportion:Float = diffX / distance;
			var yProportion:Float = diffY / distance;
			var vMagnitude:Float = Math.sqrt((_vx * _vx) + (_vy * _vy));
			
			if (distance <= _lerpTotalDistance / 2.0)
			{
				if (vMagnitude > _LERP_SPEED_)
				{
					_vx -= xProportion * _LERP_SPEED_;
					_vy -= yProportion * _LERP_SPEED_;
				}
			}
			else
			{
				_vx += xProportion * _LERP_SPEED_;
				_vy += yProportion * _LERP_SPEED_;
			}
		}
		
		if (!reachedDestination)
		{
			var newVMagnitude:Float = Math.sqrt((_vx * _vx) + (_vy * _vy));
			if (newVMagnitude >= distance - 0.5)
				reachedDestination = true;
		}
		
		// If for some reason we stopped before hitting the destination, let's count ourselves done
		var cameraHasStopped:Bool = (Math.abs(_vx) < 0.01 && Math.abs(_vy) < 0.01);
		
		// Hit destination
		if (reachedDestination || cameraHasStopped)
		{
			_lerping = false;
			_x = _lerpDestination.x;
			_y = _lerpDestination.y;
			_vx = 0;
			_vy = 0;
			_ax = 0;
			_ay = 0;
		}
	}
	
}