package actors;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxVelocity;
import flixel.FlxG;
import states.PlayState;

/**
 * ...
 * @author John Doughty
 */
class Goblin extends FlxSprite
{
	public static var goblins:FlxGroup = new FlxGroup();
	private var value:Int = 1;
	private var startY:Float;

	public function new(X:Float=0, Y:Float=0, unitHealth:Float=1.0, ?SimpleGraphic:Dynamic)
	{
		super(X, Y, SimpleGraphic);
		startY = Y;
		solid = true;
		immovable = true;
		health = unitHealth;

		setup();
	}

	private function setup()
	{
		loadGraphic(AssetPaths.goblin1__png, true, 20, 20);
		updateHitbox();
		animation.add("main", [0, 1, 2, 1], 12, true);
		flipX = true;
		animation.play("main");

		Reg.counters["goblins_launched"] += 1;

		FlxVelocity.moveTowardsPoint(this, new FlxPoint(0 - width, y), 60);
	}

	override public function update():Void
	{
		super.update();

		this.y = getTargetY();

		if (this.x < 0 - width)
		{
			Reg.score += getScore();

			kill();
		}
	}

	override public function kill():Void
	{
		super.kill();
		Reg.upgrades[getUnitTag()]["number"] -= 1;
		
		if (this.x >= 0 - width)
		{
			Reg.counters[getUnitTag() + "s_harmed"] += 1;
		}
	}

	private function getScore():Int
	{
		if (Type.getClass(FlxG.state) == PlayState)
		{
			return value;
		}
		else
		{
			return 0;
		}
	}

	private function getTargetY()
	{
		return startY;
	}

	private function getUnitTag()
	{
		return "goblin";
	}
}