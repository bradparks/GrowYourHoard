package;

import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSprite;


/**
 * ...
 * @author John Doughty
 */
class Arrow extends FlxSprite
{	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic("assets/images/arrow.png");
		//body.shapes.at(0).material.density = 1;
		//body.shapes.at(0).material.dynamicFriction = 0;
		
	}
	
}