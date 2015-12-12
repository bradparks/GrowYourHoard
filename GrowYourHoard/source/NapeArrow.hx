package;

import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeVelocity;
import flixel.group.FlxGroup;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.phys.Material;
import flixel.util.FlxRandom;

/**
 * ...
 * @author John Doughty
 */
class NapeArrow extends FlxNapeSprite
{
	public static var arrows:FlxGroup = new FlxGroup();

	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y);
		loadGraphic("assets/images/arrow.png", false, 8, 8);

		solid = true;
		antialiasing = true;
		createRectangularBody();
		setBodyMaterial();

		body.shapes.at(0).material.density = .5;
		body.applyImpulse(new Vec2(-8 * FlxRandom.floatRanged(.15, 1), -8 * FlxRandom.floatRanged(.15, 1)));
	}

	public function stop()
	{
		solid = false;
		body.allowMovement = false;
		body.allowRotation = false;
		body.disableCCD = true;
		FlxNapeVelocity.stopVelocity(this);
	}
}