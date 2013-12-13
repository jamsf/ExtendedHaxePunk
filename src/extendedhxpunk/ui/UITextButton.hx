package extendedhxpunk.ui;

import flash.geom.Point;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import extendedhxpunk.ext.EXTUtility;

/**
 * UITextButton
 * Super class for UIButton and UISmartStretchButton. Can be instantiated
 * to create a button with a label but no image.
 * Created by Fletcher, 10/27/13, Ported by Jams 11/7/13
 */
class UITextButton extends UIView
{
	/**
	 * Text to be displayed on each of the images above. Null properties will default
	 * to enabledText, except selectedHoveringText, which will default to selectedText.
	 */
	public var enabledText:Text = null;
	public var disabledText:Text = null;
	public var hoveringText:Text = null;
	public var pressedText:Text = null;
	public var selectedText:Text = null;
	public var selectedHoveringText:Text = null;
	
	/**
	 * Direct access to helpful subview
	 */
	public var label:UILabel = null;
	
	/**
	 * States and transitions
	 */
	public var enabled(get, set):Bool;
	public function get_enabled():Bool { return _enabled; }
	public function set_enabled(e:Bool):Bool { toggleEnabledState(e); return e; }
	public var selected(get, set):Bool;
	public function get_selected():Bool { return _selected; }
	public function set_selected(s:Bool):Bool { toggleSelectedState(s); return s; }
	public var selectable:Bool = false;
	public var unselectIfClickedWhileSelected:Bool = true;
	
	/**
	 * Constructor
	 * @param	position		 The initial position of the View, relative to its parent
	 * @param	size			 The initial size of the View. If null, will use baseImage's size
	 * @param	initialText		 Text to display within the button. Initializes enabledText.
	 * @param	callback		 Function to call when this button is clicked
	 * @param	callbackArgument Argument to pass to callback function, if necessary
	 */
	public function new(position:Point, size:Point, initialText:Text = null,  
								 cb:Array<Dynamic>->Dynamic = null, cbArgs:Array<Dynamic> = null)
	{
		super(position, size);
		
		_callback = cb;
		_argument = cbArgs;
		this.enabledText = initialText;
		
		this.label = new UILabel(EXTUtility.ZERO_POINT, initialText);
		this.addSubview(label);
	}
	
	/**
	 * Override UIView's update to check for user interaction
	 */
	override public function update():Void
	{
		super.update();
		
		if (this.enabled)
		{
			var needsToSendCallback:Bool = false;
			
			if (_mouseIsOverView)
			{
				if (Input.mousePressed)
				{
					_pressed = true;
					this.switchToState(PRESSED_STATE);
				}
				else if (Input.mouseReleased && _pressed)
				{
					needsToSendCallback = true;
					
					if (this.selectable)
					{
						if (!this.selected)
							this.selected = true;
						else if (this.unselectIfClickedWhileSelected)
							this.selected = false;
					}
				}
				
				if (!Input.mouseDown)
				{
					_pressed = false;
					
					if (!this.selected || !this.selectable)
						this.switchToState(HOVERING_STATE);
					else
						this.switchToState(SELECTED_HOVERING_STATE);
				}
			}
			else
			{
				_pressed = false;
				
				if (this.selected)
					this.switchToState(SELECTED_STATE);
				else
					this.switchToState(ENABLED_STATE);
			}
			
			if (needsToSendCallback)
				this.invokeCallback();
		}
		else
		{
			this.switchToState(DISABLED_STATE);
		}
	}
	
	/**
	 * Protected
	 */
	private static inline var ENABLED_STATE:UInt = 0;
	private static inline var DISABLED_STATE:UInt = 1;
	private static inline var HOVERING_STATE:UInt = 2;
	private static inline var PRESSED_STATE:UInt = 3;
	private static inline var SELECTED_STATE:UInt = 4;
	private static inline var SELECTED_HOVERING_STATE:UInt = 5;
	
	private var _enabled:Bool = true;
	private var _selected:Bool = false;
	private var _pressed:Bool = false;
	
	private var _callback:Array<Dynamic>->Dynamic;
	private var _argument:Array<Dynamic>;
	
	/**
	 * Logic to execute when switching to the given button state
	 */
	private function switchToState(state:UInt):Void
	{
		var newText:Text = label.text;
		
		switch (state)
		{
			default:
			case ENABLED_STATE:
				newText = this.enabledText;
			case DISABLED_STATE:
				newText = this.disabledText != null ? this.disabledText : this.enabledText;
			case HOVERING_STATE:
				newText = this.hoveringText != null ? this.hoveringText : this.enabledText;
			case PRESSED_STATE:
				newText = this.pressedText != null ? this.pressedText : this.enabledText;
			case SELECTED_STATE:
				newText = this.selectedText != null ? this.selectedText : this.enabledText;
			case SELECTED_HOVERING_STATE:
				if (this.selectedHoveringText != null)
					newText = this.selectedHoveringText;
				else if (this.selectedText != null)
					newText = this.selectedText;
				else
					newText = this.enabledText;
		}
		
		if (newText != label.text)
			label.text = newText;
	}
	
	/**
	 * Helpers for toggling a couple states
	 */
	public function toggleEnabledState(shouldBeOn:Bool):Void
	{
		if (shouldBeOn != _enabled)
		{
			if (shouldBeOn)
				switchToState(ENABLED_STATE);
			else
				switchToState(DISABLED_STATE);
		}
		_enabled = shouldBeOn;
	}
	
	public function toggleSelectedState(shouldBeOn:Bool):Void
	{
		if (shouldBeOn != _selected)
		{
			if (_enabled)
			{
				if (shouldBeOn)
				{
					if (!_mouseIsOverView)
						switchToState(SELECTED_STATE);
					else
						switchToState(SELECTED_HOVERING_STATE);
				}
				else
				{
					if (!_mouseIsOverView)
						switchToState(ENABLED_STATE);
					else
						switchToState(HOVERING_STATE);
				}
			}
		}
		_selected = shouldBeOn;
	}
	
	/**
	 * Send the callback for this button
	 */
	private function invokeCallback():Void
	{
		if (_callback != null)
		{
			if (_argument != null)
				_callback(_argument);
			else
				_callback([]);
		}
	}
}