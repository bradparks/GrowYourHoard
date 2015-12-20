package projectiles;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * ...
 * @author John Doughty
 */
class Axe extends FlxSprite
{
	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y);
		loadGraphic(AssetPaths.axe__png, false, 8, 8);
		animation.frameIndex = 3;

		solid = false;
		antialiasing = true;
		NapeProjectile.deadProjectiles.add(this);
	}
}