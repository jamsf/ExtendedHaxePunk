package extendedhxpunk.ui;

import flash.display.BitmapData;
import flash.geom.Point;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import extendedhxpunk.ext.EXTUtility;

/**
 * UILabel
 * A subclass of UIView which displays text within its bounds.
 * Created by Fletcher, 10/19/13
 */
class UILabel extends UIView 
{
	/**
	 * The text to display in this view
	 */
	public var text(get, set):Text;
	
	/**
	 * Constructor
	 * @param	postition	The initial position of the View, relative to its parent
	 * @param	initialText	The text to display in this view and determine its size
	 */
	public function new(position:Point, initialText:Text) 
	{
		var size:Point = initialText != null ? 
						 new Point(initialText.scaledWidth, initialText.scaledHeight) :
						 new Point();
		super(position, size);
		this.text = initialText;
	}
	
	override public function update():Void
	{
		// Update the view's size according to the size of the text
		if (this.text != null)
		{
			this.size.x = this.text.scaledWidth;
			this.size.y = this.text.scaledHeight;
		}
		
		super.update();
	}

#if !(flash || js)
	override public function removed():Void
	{
		super.removed();
		HXP.scene.remove(_textEntity);
	}
#end

	/**
	 * Private
	 */
	private var _text:Text;
#if !(flash || js)
	private var _textEntity:Entity;
#end

	public function get_text():Text { return _text; }
	public function set_text(value:Text):Text 
	{ 
		_text = value;
#if !(flash || js)
		if (_text != null)
		{
			// Text requires an attached entity when it calculates positions on hardware-rendering devices
			if (_textEntity == null)
			{
				_textEntity = HXP.scene.addGraphic(_text);
				_textEntity.visible = false;
			}
			_textEntity.graphic = _text;
			_textEntity.layer = 0;
		}
#end
		return _text;
	}

	/*
	 * Override UIView's renderContent() to render text at this location
	 * @param	absoluteUpperLeft	Screen coordinate to place content at.
	 * @param	absoluteSize		Bounds to render content within.
	 * @param	scale				Zoom level, for scaling images to match.
	 */
	override private function renderContent(buffer:BitmapData, absoluteUpperLeft:Point, absoluteSize:Point, scale:Float):Void
	{
		super.renderContent(buffer, absoluteUpperLeft, absoluteSize, scale);
		
		if (_text != null)
		{
			var oldScale:Float = _text.scale;
			_text.scale *= scale;
			_text.render(buffer, absoluteUpperLeft, EXTUtility.ZERO_POINT);
			_text.scale = oldScale;
		}
	}
}