package util;

import flixel.FlxSprite;

/**
 * ...
 * @author John Doughty
 */
class UIUnit extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0, sprite:FlxSprite) 
	{
		var scaleBy:Float = 1;
		super(X, Y);
		loadGraphicFromSprite(sprite);
		updateHitbox();
		scaleBy = 16 / height;
		scale.set(scaleBy, scaleBy);
		updateHitbox();
		animation.pause();
	}
	
}