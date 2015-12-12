package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * ...
 * @author John Doughty
 */
class Arrow extends FlxSprite
{
	public static var arrows:FlxGroup = null;

	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y);
		loadGraphic("assets/images/arrow.png", false, 8, 8);

		solid = false;
		antialiasing = true;
	}
}