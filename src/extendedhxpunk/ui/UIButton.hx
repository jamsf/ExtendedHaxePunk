package extendedhxpunk.ui;

import flash.geom.Point;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import extendedhxpunk.ext.EXTUtility;
import extendedhxpunk.ui.UIImageView;

/**
 * UIButton
 * A subclass of UIView which registers clicks, invokes callbacks when clicked,
 *    and handles a visual clickable representation.
 * Created by Fletcher, 10/20/13
 */
class UIButton extends UITextButton
{
	/**
	 * enabledImage : Image to be displayed when button is enabled for interaction and
	 *   not being interacted with. Is also used for other states as a default.
	 */
	public var enabledImage(get, set):Image;
	public function get_enabledImage():Image { return _enabledImage; }
	public function set_enabledImage(i:Image):Image { _enabledImage = i; updateImageSize(i); return i; }
	
	/**
	 * disabledImage : Image displayed when this button is not enabled for interaction
	 */
	public var disabledImage(get, set):Image;
	public function get_disabledImage():Image { return _disabledImage; }
	public function set_disabledImage(i:Image):Image { _disabledImage = i; updateImageSize(i); return i; }
	
	/**
	 * hoveringImage : Image displayed when button is enabled and mouse is hovering above it
	 */
	public var hoveringImage(get, set):Image;
	public function get_hoveringImage():Image { return _hoveringImage; }
	public function set_hoveringImage(i:Image):Image { _hoveringImage = i; updateImageSize(i); return i; }
	
	/**
	 * pressedImage : Image displayed when button is enabled and mouse is holding down on it
	 */
	public var pressedImage(get, set):Image;
	public function get_pressedImage():Image { return _pressedImage; }
	public function set_pressedImage(i:Image):Image { _pressedImage = i; updateImageSize(i); return i; }
	
	/**
	 * selectedImage : Image displayed when button is enabled and in the selected state
	 */
	public var selectedImage(get, set):Image;
	public function get_selectedImage():Image { return _selectedImage; }
	public function set_selectedImage(i:Image):Image { _selectedImage = i; updateImageSize(i); return i; }
	
	/**
	 * selectedHoveringImage : Image displayed mouse is hovering over button in selected state.
	 * 						   Rather than enabledImage, uses selectedImage as default.
	 */
	public var selectedHoveringImage(get, set):Image;
	public function get_selectedHoveringImage():Image { return _selectedHoveringImage; }
	public function set_selectedHoveringImage(i:Image):Image { _selectedHoveringImage = i; updateImageSize(i); return i; }
	
	/**
	 * Direct access to helpful subview
	 */
	public var imageView:UIImageView = null;
	
	/**
	 * Constructor
	 * @param	position		 The initial position of the View, relative to its parent
	 * @param	size			 The initial size of the View. If null, will use baseImage's size
	 * @param	baseImage		 enabledImage's initial value, and default image for other states
	 * @param	initialText		 Text to display within the button
	 * @param	callback		 Function to call when this button is clicked
	 * @param	callbackArgument Argument to pass to callback function, if necessary
	 */
	public function new(position:Point, size:Point, baseImage:Image, initialText:Text = null, 
							 cb:Array<Dynamic>->Dynamic = null, cbArgs:Array<Dynamic> = null)
	{
		if (size == null && baseImage != null)
			size = new Point(baseImage.width, baseImage.height);
		
		if (baseImage != null)
		{
			_enabledImage = baseImage;
			baseImage.scaledWidth = size.x;
			baseImage.scaledHeight = size.y;
		}
		
		this.imageView = new UIImageView(EXTUtility.ZERO_POINT, _enabledImage);
		this.addSubview(imageView);
		
		super(position, size, initialText, cb, cbArgs);
	}
	
	/**
	 * Protected
	 */
	private var _enabledImage:Image = null;
	private var _disabledImage:Image = null;
	private var _hoveringImage:Image = null;
	private var _pressedImage:Image = null;
	private var _selectedImage:Image = null;
	private var _selectedHoveringImage:Image = null;
	
	private function updateImageSize(image:Image):Void
	{
		if (image != null)
		{
			image.scaledWidth = this.size.x;
			image.scaledHeight = this.size.y;
		}
	}
	
	override private function switchToState(state:UInt):Void
	{
		super.switchToState(state);
		
		var newImage:Image = imageView.image;
		
		switch (state)
		{
			default:
			case UITextButton.ENABLED_STATE:
				newImage = _enabledImage;
			case UITextButton.DISABLED_STATE:
				newImage = _disabledImage != null ? _disabledImage : _enabledImage;
			case UITextButton.HOVERING_STATE:
				newImage = _hoveringImage != null ? _hoveringImage : _enabledImage;
			case UITextButton.PRESSED_STATE:
				newImage = _pressedImage != null ? _pressedImage : _enabledImage;
			case UITextButton.SELECTED_STATE:
				newImage = _selectedImage != null ? _selectedImage : _enabledImage;
			case UITextButton.SELECTED_HOVERING_STATE:
				if (_selectedHoveringImage != null)
					newImage = _selectedHoveringImage;
				else if (_selectedImage != null)
					newImage = _selectedImage;
				else
					newImage = _enabledImage;
		}
		
		if (newImage != imageView.image)
			imageView.image = newImage;
	}
}