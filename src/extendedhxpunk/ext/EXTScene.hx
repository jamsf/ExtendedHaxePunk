package extendedhxpunk.ext;

import flash.geom.Point;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import extendedhxpunk.ui.UIViewController;

/**
 * Extended Scene
 * Subclass of HaxePunk's World which now contains references
 * to a fully functional camera and root UI objects.
 * Created by Fletcher, 8/25/13, ported by Jams 11/11/13
 */
class EXTScene extends Scene
{
	public var worldCamera:EXTCamera;
	public var staticUiController:UIViewController;		// Controls non-camera relative UI
	public var relativeUiController:UIViewController;	// Controls camera relative UI
	
	/**
	 * Constructor
	 */
	public function new()
	{
		super();
		
		_entities = new Map();
		var screenSize:Point = new Point(HXP.screen.width, HXP.screen.height);
		worldCamera = new EXTCamera();
		staticUiController = new UIViewController(screenSize);
		relativeUiController = new UIViewController(screenSize, worldCamera);
	}
	
	/**
	 * Update the world's camera, entities, and UI
	 */
	override public function update():Void
	{
		// Update the world, and camera
		worldCamera.update();
		super.update();
		
		// Prepare the world for rendering using camera's position
		this.camera.x = Std.int(this.worldCamera.x * this.worldCamera.zoom);
		this.camera.y = Std.int(this.worldCamera.y * this.worldCamera.zoom);
		
		// Update the UI
		relativeUiController.update();
		staticUiController.update();
	}
	
	/**
	 * Render the world's entities and UI
	 */
	override public function render():Void
	{
		// Make sure to apply our camera's zoom to our entities' images
		//NOTE - This hackish solution for zooming allows us the desired effect without
		//		 directly messing with Flashpunk's code or other overhead like adding a
		//		 number of subclasses
		var needToApplyZoom:Bool = worldCamera.zoom != 1.0 && worldCamera.zoom != 0.0;
		
		if (needToApplyZoom)
			this.applyCameraZoomToEntities();
		
		// Render the entities
		super.render();
			
		if (needToApplyZoom)
			this.removeCameraZoomFromEntities();
		
		// Render the UI
		relativeUiController.render();
		staticUiController.render();
	}
	
	/**
	 * Adds the Entity to the World at the end of the frame.
	 * Overridden so we can keep track of entities.
	 * @param	e		Entity object you want to add
	 * @return	The added Entity object
	 */
	override public function add<E:Entity>(e:E):E
	{
		_entities.set(e, true);
		return super.add(e);
	}
	
	override public function remove<E:Entity>(e:E):E
	{
		_entities.remove(e);
		return super.remove(e);
	}

	/**
	 * Get the top-most entity colliding with the given position
	 */
	public function topMostCollidePoint(type:String, x:Int, y:Int):Entity
	{
		var entities:Array<Entity> = new Array();
		this.collidePointInto(type, x, y, entities);
		if (entities.length > 0)
		{
			entities.sort( function(a:Entity, b:Entity):Int
			{
			    var layerA = a.layer;
			    var layerB = b.layer;
			    if (layerA < layerB) return -1;
			    if (layerA > layerB) return 1;
			    return 0;
			} );
			return entities[0];
		}
		return null;
	}

	/**
	 * Protected
	 * See NOTE in render() method above for explanation of usage
	 */
	private var _entities:Map<Entity, Bool>; // TODO - fcole - HashSet?
	
	private function applyCameraZoomToEntities():Void
	{
		for (entity in _entities.keys())
		{
			entity.x *= worldCamera.zoom;
			entity.y *= worldCamera.zoom;
			var entityGraphic:Graphic = entity.graphic;

			if (Std.is(entityGraphic, Image))
				applyCameraZoomToImage(cast entityGraphic);

			else if (Std.is(entityGraphic, Graphiclist))
				applyCameraZoomToGraphiclist(cast entityGraphic);
			
			if (entityGraphic != null)
			{
				entityGraphic.x *= worldCamera.zoom;
				entityGraphic.y *= worldCamera.zoom;
			}
		}
	}

	private function applyCameraZoomToGraphiclist(graphiclist:Graphiclist)
	{
		var graphicsArray:Array<Graphic> = graphiclist.children;
		for (i in 0...graphicsArray.length)
		{
			var graphic:Graphic = graphicsArray[i];

			if (Std.is(graphic, Image))
				applyCameraZoomToImage(cast graphic);

			else if (Std.is(graphic, Graphiclist))
				applyCameraZoomToGraphiclist(cast graphic);

			graphic.x *= worldCamera.zoom;
			graphic.y *= worldCamera.zoom;
		}
	}

	private function applyCameraZoomToImage(image:Image):Void
	{
		image.scaledWidth = image.scaledWidth * worldCamera.zoom + 0.5;
		image.scaledHeight = image.scaledHeight * worldCamera.zoom + 0.5;
		//image.scale *= worldCamera.zoom;
	}
	
	private function removeCameraZoomFromEntities():Void
	{
		for (entity in _entities.keys())
		{
			entity.x /= worldCamera.zoom;
			entity.y /= worldCamera.zoom;
			var entityGraphic:Graphic = entity.graphic;

			if (Std.is(entityGraphic, Image))
				removeCameraZoomFromImage(cast entityGraphic);

			else if (Std.is(entityGraphic, Graphiclist))
				removeCameraZoomFromGraphiclist(cast entityGraphic);
			
			if (entityGraphic != null)
			{
				entityGraphic.x /= worldCamera.zoom;
				entityGraphic.y /= worldCamera.zoom;
			}
		}
	}

	private function removeCameraZoomFromGraphiclist(graphiclist:Graphiclist)
	{
		var graphicsArray:Array<Graphic> = graphiclist.children;
		for (i in 0...graphicsArray.length)
		{
			var graphic:Graphic = graphicsArray[i];

			if (Std.is(graphic, Image))
				removeCameraZoomFromImage(cast graphic);

			else if (Std.is(graphic, Graphiclist))
				removeCameraZoomFromGraphiclist(cast graphic);

			graphic.x /= worldCamera.zoom;
			graphic.y /= worldCamera.zoom;
		}
	}

	private function removeCameraZoomFromImage(image:Image):Void
	{
		image.scaledWidth = (image.scaledWidth - 0.5) / worldCamera.zoom;
		image.scaledHeight = (image.scaledHeight - 0.5) / worldCamera.zoom;
		//image.scale /= worldCamera.zoom;
	}
}
