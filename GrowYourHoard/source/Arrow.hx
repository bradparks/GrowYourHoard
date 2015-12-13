package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * ...
 * @author John Doughty
 */
class Arrow extends FlxSprite
{
	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y);
		loadGraphic(AssetPaths.arrow__png, false, 8, 8);

		solid = false;
		antialiasing = true;
		NapeProjectile.deadProjectiles.add(this);
	}
}