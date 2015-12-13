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
class NapeArrow extends FlxNapeSprite
{
	public static var arrows:FlxGroup = null;
	public var spawnedArrow:Arrow;
	
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

		Reg.counters["arrows_launched"] += 1;
	}

	public function stop()
	{
		spawnedArrow = new Arrow(this.x, this.y);
		Arrow.arrows.add(spawnedArrow);
		FlxG.state.add(Arrow.arrows);

		this.destroy();
	}

	override public function update():Void
	{
		super.update();

		if (this.y > 177)
		{
			this.stop();
		}
	}

	override public function destroy():Void
	{
		NapeArrow.arrows.remove(this, true);
		super.destroy();
	}
}