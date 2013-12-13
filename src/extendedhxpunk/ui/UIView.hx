package extendedhxpunk.ui;

import com.haxepunk.graphics.Image;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

import com.haxepunk.graphics.atlas.Atlas;
import com.haxepunk.graphics.atlas.TextureAtlas;
import com.haxepunk.graphics.atlas.AtlasRegion;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.utils.Input;
import extendedhxpunk.ext.EXTColor;
import extendedhxpunk.ext.EXTOffsetType;
import extendedhxpunk.ext.EXTUtility;
import extendedhxpunk.ext.EXTConsole;
	
/**
 * UIView
 * Super class for all UI elements. UI should generally be structured as a tree
 *    of UIViews (and it's subclasses), with the subviews to be located within
 *    the parent views, and adopting the parents' transformations.
 * @author Fletcher, 4/25/13, Ported by Jams, 11/8/13
 */
class UIView
{
	/**
	 * Standard positioning fields
	 */
	public var position:Point;
	public var size:Point;
	
	/**
	 * Offsets to measure positions from.
	 * Defaults to centering this view in the center of it's parent's view.
	 */
	public var offsetAlignmentInParent:EXTOffsetType;
	public var offsetAlignmentForSelf:EXTOffsetType;
	
	/**
	 * Accessor for setting the background of the View to a constant color.
	 * Useful for debugging, or for drawing colored quads in UI.
	 */
	public var backgroundColor(get, never):EXTColor; 
	public function get_backgroundColor():EXTColor
	{ 
		if (_backgroundColor == null)
			_backgroundColor = new EXTColor();
		return _backgroundColor;
	}
	
	/**
	 * Accessor for detecting if the mouse is currently hovering over
	 * this View or any of its subviews
	 */
	public var mouseIsOverViewOrSubviews(get, never):Bool;
	public function get_mouseIsOverViewOrSubviews():Bool
	{
		if (_mouseIsOverView)
			return true;
		if (_subviews != null)
		{
			for (view in _subviews)
			{
				if (view.mouseIsOverViewOrSubviews)
					return true;
			}
		}
		return false;
	}
	
	/**
	 * Constructor. Set up initial transforms.
	 * Use these parameters in conjunction with offset types above to determine layout.
	 * @param	position	The initial position of the View, relative to its parent
	 * @param	size		The initial size of the View
	 */
	public function new(position:Point, size:Point) 
	{
		offsetAlignmentInParent = EXTOffsetType.CENTER;
		offsetAlignmentForSelf = EXTOffsetType.CENTER;
		
		this.position = new Point(position.x, position.y);
		this.size = new Point(size.x, size.y);
	}
	
	/**
	 * Add a subview, which inherits the transforms of this view, as a subview.
	 * @param	subview	The View to add as a subview
	 */
	public function addSubview(subview:UIView):Void
	{
		if (subview != null)
		{
			if (_subviews == null)
				_subviews = new Array<UIView>();
			_subviews.push(subview);
		}
	}
	
	/**
	 * Remove a View from this View's list of subviews.
	 * NOTE - Only removes the first occurrence, if there are multiple.
	 * @param	subview	The View to remove from this View's subviews.
	 * @return	The View which was removed, or null if it wasn't found.
	 */
	public function removeSubview(subview:UIView):UIView
	{
		var removedView:UIView = null;
		
		if (subview != null && _subviews != null)
		{
			var removed:Array<UIView>  = _subviews.splice(Lambda.indexOf(_subviews, subview), 1);
			if (removed != null && removed.length > 0)
				removedView = removed.pop();
		}
		return removedView;
	}
	
	/**
	 * If the specified subview exists in our list of subviews,
	 * mark it to be rendered last, which visualizes it in front.
	 */
	public function bringSubviewToFront(subview:UIView):Void
	{
		if (subview != null && _subviews != null)
		{
			var foundView:UIView = this.removeSubview(subview);
			if (foundView != null)
				_subviews.push(subview);
		}	
	}
	
	/**
	 * 
	 */
	public function sendSubviewToBack(subview:UIView):Void
	{
		if (subview != null && _subviews != null)
		{
			var foundView:UIView = this.removeSubview(subview);
			if (foundView != null)
				_subviews.unshift(subview);
		}
	}
	
	/**
	 * Update the View. Override this function in order to perform 
	 *    view-specific computations, but remember to call super.update()
	 *    or the subviews will not be updated.
	 */
	public function update():Void
	{
		if (_subviews != null)
		{
			for (view in _subviews)
				view.update();
		}
	}
	
	/**
	 * Render the View. This function should NOT need to be overridden in normal cases.
	 * @param	buffer					Either FP.buffer or custom buffer. TODO - See if this works for RenderMode.HARDWARE
	 * @param	parentAbsolutePosition	The true upper left screen coordinate of the parent view.
	 * @param	parentSize				The true drawing size of the parent.
	 * @param	scale					How much to scale the view by - Used to account for zoom in camera-relative UI.
	 */
	public function render(buffer:BitmapData, parentAbsolutePosition:Point, parentSize:Point, scale:Float):Void
	{
		var myOffset:Point = new Point(this.position.x, this.position.y);
		var mySize:Point = new Point(this.size.x, this.size.y);
		
		if (scale != 1.0)
		{
			myOffset.x *= scale;
			myOffset.y *= scale;
			mySize.x *= scale;
			mySize.y *= scale;
		}
		
		var myRelativeUpperLeft:Point = EXTUtility.UpperLeftifyCoordinate(myOffset, mySize, this.offsetAlignmentForSelf);
		var myAbsoluteUpperLeft:Point = EXTUtility.AbsolutePositionOfPointInContainer(parentAbsolutePosition, parentSize, myRelativeUpperLeft, this.offsetAlignmentInParent);
		
		// Logic to render content of this view occurs now
		this.renderContent(buffer, myAbsoluteUpperLeft, mySize, scale);
		
		// Now we draw our subviews
		if (_subviews != null)
		{
			for (view in _subviews)
				view.render(buffer, myAbsoluteUpperLeft, mySize, scale);
		}
	}
	
	/**
	 * Protected
	 * 
	 * Array of subviews
	 * Public access through addSubview() and removeSubview()
	 */
	private var _subviews:Array<UIView> = null;
	
	/**
	 * Handling of background color
	 */
	private var _backgroundColor:EXTColor = null;
	private var _backgroundColorCanvas:Canvas = null;
	private var _backgroundColorRectangle:Rectangle = null;
	//private var _backgroundColorImage:Image = null;
	
	/**
	 * Whether the mouse is currently over the absolute location of this view
	 */
	private var _mouseIsOverView:Bool = false;
	
	/**
	 * Logic to render any content specific to a given UIView subclass. Even still,
	 *    should usually only be overridden by UIImageView and UILabel.
	 * @param	buffer				This can be either BitmapData for bitmap (flash) or AtlasRegion (hardware accelerated)
	 * @param	absoluteUpperLeft	Screen coordinate to place content at.
	 * @param	absoluteSize		Bounds to render content within.
	 * @param	scale				Zoom level, for scaling images to match.
	 */
	private function renderContent(buffer:BitmapData, absoluteUpperLeft:Point, absoluteSize:Point, scale:Float):Void
	{
		if (_backgroundColor != null)
		{
#if flash
			if (_backgroundColorCanvas == null)
			{
				_backgroundColorCanvas = new Canvas(HXP.screen.width, HXP.screen.height);
				_backgroundColorRectangle = new Rectangle();
			}
			
			_backgroundColorRectangle.width = absoluteSize.x;
			_backgroundColorRectangle.height = absoluteSize.y;
			_backgroundColorCanvas.fill(_backgroundColorRectangle, _backgroundColor.webColor, _backgroundColor.alpha);
			//EXTConsole.debug("UIView", "renderContent()", [_backgroundColor.webColor, _backgroundColor.argbWebColor, _backgroundColor.alpha, ((_backgroundColor.argbWebColor & 0xFF000000) >> 24)]);
			_backgroundColorCanvas.render(buffer, absoluteUpperLeft, EXTUtility.ZERO_POINT);
#else
//TODO - fcole - What do we do here?
			//if (_backgroundColorImage == null)
			//{
				//_backgroundColorImage = Image.createRect(Std.int(absoluteSize.x), Std.int(absoluteSize.y), _backgroundColor.rgbWebColor, _backgroundColor.alpha);
				//_backgroundColorRectangle = new Rectangle();
			//}
			//
			//_backgroundColorRectangle.width = absoluteSize.x;
			//_backgroundColorRectangle.height = absoluteSize.y;
			//_backgroundColorRectangle.x = absoluteUpperLeft.x;
			//_backgroundColorRectangle.y = absoluteUpperLeft.y;
			//buffer.fillRect(_backgroundColorRectangle, _backgroundColor.argbWebColor);
			//_backgroundColorImage.render(buffer, absoluteUpperLeft, EXTUtility.ZERO_POINT);
#end
		}
		
		//TODO - fcole - This possibly shouldn't be done during the render phase, should the UI
		//    update tree also contain absolute position information?
		_mouseIsOverView = EXTUtility.PointIsInsideContainer(new Point(Input.mouseX, Input.mouseY), absoluteUpperLeft, absoluteSize, EXTOffsetType.TOP_LEFT);
		
		// Overridden in UIImageView and UILabel
	}
}