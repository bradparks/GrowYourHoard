package;

import flixel.FlxSprite;


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
		
	}
	
}