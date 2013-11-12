package extendedhxpunk.ui;

import flash.geom.Point;
import flash.geom.Rectangle;
import com.haxepunk.graphics.Image;
import extendedhxpunk.ext.EXTUtility;
import extendedhxpunk.ext.EXTOffsetType;

/**
 * UISmartImageStretchView
 * A subclass of UIView which renders an image that is stretched to
 *    fit the view size, but only stretches the middle of the image
 *    so that there are no artifacts around the sides of the image.
 * @author by Fletcher, 10/20/13, ported by Jams, 11/11/13
 */
class UISmartImageStretchView extends UIView 
{
	/**
	 * Constructor
	 * @param	position The position of the View, relative to its parent
	 * @param	size	 The size of the View. NOTE - Should be bigger than the image's size
	 * @param	source	 The source image class, used to create the Images that compose this view
	 */
	public function new(position:Point, size:Point, source:Dynamic) 
	{
		super(position, size);
		
		var normalImage:Image = new Image(source);
		if (normalImage != null)
		{
			// Get the necessary image components
			var halfW:UInt = Std.int(normalImage.width / 2);
			var halfH:UInt = Std.int(normalImage.height / 2);
			
			var centerChunk:Rectangle = new Rectangle(halfW - 1, halfH - 1, 3, 3);
			var centerImage:Image = new Image(source, centerChunk);
			
			var horizontalLeftSlice:Rectangle = new Rectangle(0, halfH - 1, halfW - 1, 3);
			var horizontalLeftSliceImage:Image = new Image(source, horizontalLeftSlice);
			
			var horizontalRightSlice:Rectangle = new Rectangle(halfW + 1, halfH - 1, halfW - 1, 3);
			var horizontalRightSliceImage:Image = new Image(source, horizontalRightSlice);
			
			var verticalTopSlice:Rectangle = new Rectangle(halfW - 1, 0, 3, halfH - 1);
			var verticalTopSliceImage:Image = new Image(source, verticalTopSlice);
			
			var verticalBottomSlice:Rectangle = new Rectangle(halfW - 1, halfH + 1, 3, halfH - 1);
			var verticalBottomSliceImage:Image = new Image(source, verticalBottomSlice);
			
			var upperLeftCorner:Rectangle = new Rectangle(0, 0, halfW - 1, halfH - 1);
			var upperLeftCornerImage:Image = new Image(source, upperLeftCorner);
			
			var upperRightCorner:Rectangle = new Rectangle(halfW + 1, 0, halfW - 1, halfH - 1);
			var upperRightCornerImage:Image = new Image(source, upperRightCorner);
			
			var lowerRightCorner:Rectangle = new Rectangle(halfW + 1, halfH + 1, halfW - 1, halfH - 1);
			var lowerRightCornerImage:Image = new Image(source, lowerRightCorner);
			
			var lowerLeftCorner:Rectangle = new Rectangle(0, halfH + 1, halfW - 1, halfH - 1);
			var lowerLeftCornerImage:Image = new Image(source, lowerLeftCorner);
			
			// Create the separate image views from our components
			centerImage.scaledWidth = size.x - normalImage.width + 3;
			centerImage.scaledHeight = size.y - normalImage.height + 3;
			var centerStretchView:UIImageView = new UIImageView(EXTUtility.ZERO_POINT, centerImage);
			
			verticalTopSliceImage.scaledWidth = size.x - normalImage.width + 3;
			var horizontalTopStretchView:UIImageView = new UIImageView(EXTUtility.ZERO_POINT, verticalTopSliceImage);
			horizontalTopStretchView.offsetAlignmentInParent = EXTOffsetType.TOP_CENTER;
			horizontalTopStretchView.offsetAlignmentForSelf = EXTOffsetType.TOP_CENTER;
			
			verticalBottomSliceImage.scaledWidth = size.x - normalImage.width + 3;
			var horizontalBottomStretchView:UIImageView = new UIImageView(EXTUtility.ZERO_POINT, verticalBottomSliceImage);
			horizontalBottomStretchView.offsetAlignmentInParent = EXTOffsetType.BOTTOM_CENTER;
			horizontalBottomStretchView.offsetAlignmentForSelf = EXTOffsetType.BOTTOM_CENTER;
			
			horizontalLeftSliceImage.scaledHeight = size.y - normalImage.height + 3;
			var verticalLeftStretchView:UIImageView = new UIImageView(EXTUtility.ZERO_POINT, horizontalLeftSliceImage);
			verticalLeftStretchView.offsetAlignmentInParent = EXTOffsetType.LEFT_CENTER;
			verticalLeftStretchView.offsetAlignmentForSelf = EXTOffsetType.LEFT_CENTER;
			
			horizontalRightSliceImage.scaledHeight = size.y - normalImage.height + 3;
			var verticalRightStretchView:UIImageView = new UIImageView(EXTUtility.ZERO_POINT, horizontalRightSliceImage);
			verticalRightStretchView.offsetAlignmentInParent = EXTOffsetType.RIGHT_CENTER;
			verticalRightStretchView.offsetAlignmentForSelf = EXTOffsetType.RIGHT_CENTER;
			
			var upperLeftImageView:UIImageView = new UIImageView(EXTUtility.ZERO_POINT, upperLeftCornerImage);
			upperLeftImageView.offsetAlignmentInParent = EXTOffsetType.TOP_LEFT;
			upperLeftImageView.offsetAlignmentForSelf = EXTOffsetType.TOP_LEFT;
			
			var upperRightImageView:UIImageView = new UIImageView(EXTUtility.ZERO_POINT, upperRightCornerImage);
			upperRightImageView.offsetAlignmentInParent = EXTOffsetType.TOP_RIGHT;
			upperRightImageView.offsetAlignmentForSelf = EXTOffsetType.TOP_RIGHT;
			
			var lowerRightImageView:UIImageView = new UIImageView(EXTUtility.ZERO_POINT, lowerRightCornerImage);
			lowerRightImageView.offsetAlignmentInParent = EXTOffsetType.BOTTOM_RIGHT;
			lowerRightImageView.offsetAlignmentForSelf = EXTOffsetType.BOTTOM_RIGHT;
			
			var lowerLeftImageView:UIImageView = new UIImageView(EXTUtility.ZERO_POINT, lowerLeftCornerImage);
			lowerLeftImageView.offsetAlignmentInParent = EXTOffsetType.BOTTOM_LEFT;
			lowerLeftImageView.offsetAlignmentForSelf = EXTOffsetType.BOTTOM_LEFT;
			
			// Add the subviews
			this.addSubview(centerStretchView);
			this.addSubview(horizontalTopStretchView);
			this.addSubview(horizontalBottomStretchView);
			this.addSubview(verticalLeftStretchView);
			this.addSubview(verticalRightStretchView);
			this.addSubview(upperLeftImageView);
			this.addSubview(upperRightImageView);
			this.addSubview(lowerRightImageView);
			this.addSubview(lowerLeftImageView);
		}
	}
}