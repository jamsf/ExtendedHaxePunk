package extendedhxpunk.ui;

import flash.display.BitmapData;
import flash.geom.Point;

import com.haxepunk.HXP;
import extendedpunk.ext.EXTCamera;
import extendedpunk.ext.EXTUtility;
import extendedpunk.ui.UIView;

/**
 * UIViewController
 * Top level of a UIView tree. May be configured to manage its views
 *    relative to a camera, or be placed statically on the screen.
 * @author by Fletcher, 9/7/13, Ported by Jams 11/7/13
 */
class UIViewController 
{
	/**
	 * The root view of the UI tree managed by this controller.
	 * UI for this tree should be added as subviews to this view.
	 */
	public var rootView:UIView;
	
	/**
	 * Set this to render the views in this tree to a custom buffer
	 * By default we use FP.buffer
	 */
	//TODO - fcole - Test that this works
	public var customBuffer:BitmapData = null;
	
	/**
	 * Constructor. Usually UI positioning is independent of camera location,
	 *    but a camera to draw relative to may be specified if there is a 
	 *    desire to have UIViews located in the game word. The bounds of a 
	 *    view controller are usually equal to the size of the screen.
	 * @param	bounds		Size of the view area of this view controller.
	 * @param	camera		[Optional] Camera to measure relative positions to.
	 */
	public function UIViewController(bounds:Point, camera:EXTCamera = null) 
	{
		rootView = new UIView(EXTUtility.ZERO_POINT, EXTUtility.ZERO_POINT);
		_bounds = bounds;
		_camera = camera;
	}
	
	/**
	 * Update the UI owned by this controller
	 */
	public function update():void
	{
		rootView.update();
	}
	
	/**
	 * Render the UI owned by this controller
	 */
	public function render():void
	{
		var offsetPosition:Point = EXTUtility.ZERO_POINT;
		var bounds:Point = new Point(_bounds.x, _bounds.y);
		var scale:Number = 1.0;
		
		if (_camera != null)
		{
			offsetPosition = new Point(-_camera.x * _camera.zoom, -_camera.y * _camera.zoom);
			scale = _camera.zoom;
			bounds.x *= scale;
			bounds.y *= scale;
		}
		
		var bufferToUse:BitmapData = this.customBuffer != null ? this.customBuffer : FP.buffer;
		rootView.render(bufferToUse, offsetPosition, bounds, scale);
	}
	
	/**
	 * Protected
	 */
	protected var _bounds:Point = null;
	protected var _camera:EXTCamera = null;
}