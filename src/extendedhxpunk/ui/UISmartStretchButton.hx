package extendedhxpunk.ui;

import flash.geom.Point;

import com.haxepunk.graphics.Text;
import extendedhxpunk.ext.EXTUtility;

/**
 * UISmartStretchButton
 * Another button type (in addition to UIButton) which leverages
 * UISmartImageStretchView to create a button by stretching a 
 * base image without artifacts around the sides.
 * @author Fletcher, 10/22/13, ported by Jams, 11/11/13
 */
class UISmartStretchButton extends UITextButton
{
	/**
	 * Direct access to specific subviews
	 */
	public var enabledView:UISmartImageStretchView = null;
	public var disabledView:UISmartImageStretchView = null;
	public var hoveringView:UISmartImageStretchView = null;
	public var pressedView:UISmartImageStretchView = null;
	public var selectedView:UISmartImageStretchView = null;
	public var selectedHoveringView:UISmartImageStretchView = null;
	
	/**
	 * Constructor
	 * Each of the source paramaters should be the image source to create the
	 * the Image objects for the button with. Unspecified images will default
	 * to enabledImageSource, except for selectedHoveringImageSource, which
	 * defaults to selectedImageSource.
	 * @param	position	The initial position of the View, relative to its parent
	 * @param	size		The initial size of the View
	 * @param	enabledImageSource			Source for enabled state Image
	 * @param	disabledImageSource			Source for disabled state Image
	 * @param	hoveringImageSource			Source for hovering state Image
	 * @param	pressedImageSource			Source for pressed state Image
	 * @param	selectedImageSource			Source for selected state Image
	 * @param	selectedHoveringImageSource	Source for selected hovering state Image
	 * @param	initialText		 Text to display within the button. Initializes enabledText.
	 * @param	callback		 Function to call when this button is clicked
	 * @param	callbackArgument Argument to pass to callback function, if necessary
	 */
	public function new(position:Point, size:Point, 
										 enabledImageSource:Dynamic, 
										 disabledImageSource:Dynamic = null,
										 hoveringImageSource:Dynamic = null,
										 pressedImageSource:Dynamic = null,
										 selectedImageSource:Dynamic = null,
										 selectedHoveringImageSource:Dynamic = null,
										 initialText:Text = null,
										 cb:Array<Dynamic>->Dynamic = null, 
										 cbArgs:Array<Dynamic> = null) 
	{
		this.enabledView = new UISmartImageStretchView(EXTUtility.ZERO_POINT, size, enabledImageSource);
		
		if (disabledImageSource != null)
			this.disabledView = new UISmartImageStretchView(EXTUtility.ZERO_POINT, size, disabledImageSource);
		else
			this.disabledView = this.enabledView;
		
		if (hoveringImageSource != null)
			this.hoveringView = new UISmartImageStretchView(EXTUtility.ZERO_POINT, size, hoveringImageSource);
		else
			this.hoveringView = this.enabledView;
		
		if (pressedImageSource != null)
			this.pressedView = new UISmartImageStretchView(EXTUtility.ZERO_POINT, size, pressedImageSource);
		else
			this.pressedView = this.enabledView;
		
		if (selectedImageSource != null)
			this.selectedView = new UISmartImageStretchView(EXTUtility.ZERO_POINT, size, selectedImageSource);
		else
			this.selectedView = this.enabledView;
		
		if (selectedHoveringImageSource != null)
			this.selectedHoveringView = new UISmartImageStretchView(EXTUtility.ZERO_POINT, size, selectedHoveringImageSource);
		else
			this.selectedHoveringView = this.selectedView;
		
		super(position, size, initialText, cb, cbArgs);
	}
	
	/**
	 * Protected
	 */
	private var _currentView:UISmartImageStretchView = null;
	
	override private function switchToState(state:UInt):Void
	{
		super.switchToState(state);
		
		var newView:UISmartImageStretchView = _currentView;
		
		switch (state)
		{
			default:
			case UITextButton.ENABLED_STATE:
				newView = this.enabledView;
			case UITextButton.DISABLED_STATE:
				newView = this.disabledView;
			case UITextButton.HOVERING_STATE:
				newView = this.hoveringView;
			case UITextButton.PRESSED_STATE:
				newView = this.pressedView;
			case UITextButton.SELECTED_STATE:
				newView = this.selectedView;
			case UITextButton.SELECTED_HOVERING_STATE:
				newView = this.selectedHoveringView;
		}
		
		if (newView != _currentView)
		{
			this.removeSubview(_currentView);
			this.addSubview(newView);
			this.sendSubviewToBack(newView);
			_currentView = newView;
		}
	}
}