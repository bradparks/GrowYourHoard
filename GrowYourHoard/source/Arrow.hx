package;

import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSprite;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.phys.Material;
import flixel.util.FlxRandom;

/**
 * ...
 * @author John Doughty
 */
class Arrow extends FlxNapeSprite
{	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic("assets/images/arrow.png",false,8,8);
		
		antialiasing = true;
		createRectangularBody();
		antialiasing = true;
		setBodyMaterial();
		
		//body.shapes.add(circle);
		//body.cbTypes.add(Balloons.CB_BALLOON);
		//body.userData.data = this;
		
		body.shapes.at(0).material.density = .5;
		body.applyImpulse(new Vec2(-8 * FlxRandom.floatRanged( .15, 1), -8 * FlxRandom.floatRanged( .15, 1)));
		
		
	}
	
}