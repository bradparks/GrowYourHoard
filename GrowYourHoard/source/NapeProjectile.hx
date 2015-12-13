package;

import flixel.FlxG;
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
class NapeProjectile extends FlxNapeSprite
{
	public var spawnedArrow:FlxSprite;
	public var damage:Int = 1;
	public static var projectiles:FlxGroup = null;
	public static var deadProjectiles:FlxGroup = null;

	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y);
		setupGraphics();
		setupBodies();
		countUpLaunched();
	}

	public function setupGraphics()
	{
	}

	public function setupBodies()
	{
		solid = true;
		antialiasing = true;
		createRectangularBody();
		setBodyMaterial();

		body.shapes.at(0).material.density = .5;
		body.applyImpulse(new Vec2(-8 * FlxRandom.floatRanged(.15, 1), -8 * FlxRandom.floatRanged(.15, 1)));
	}

	public function countUpLaunched()
	{
	}

	public function countUpBlocked()
	{
	}

	public function getSpawnedSprite(x:Float,y:Float):FlxSprite
	{
		return new FlxSprite(x, y);
	}

	public function stop(minX:Float, maxX:Float)
	{
		var newX:Float = (x < minX ? minX : (x > maxX ? maxX : x));

		spawnedArrow = getSpawnedSprite(newX, y);
		deadProjectiles.add(spawnedArrow);
		FlxG.state.add(deadProjectiles);

		this.x = -1;
		kill();
	}

	override public function update():Void
	{
		super.update();

		if (this.y > 203)
		{
			this.stop(x, x);
		}
	}
}