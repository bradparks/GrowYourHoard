package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxVelocity;

/**
 * ...
 * @author John Doughty
 */
class Goblin extends FlxSprite
{
	public static var goblins:FlxGroup = null;

	public function new(X:Float=0, Y:Float=0, unitHealth:Float=1.0, ?SimpleGraphic:Dynamic)
	{
		super(X, Y, SimpleGraphic);

		solid = true;
		immovable = true;
		health = unitHealth;

		setup();
	}

	private function setup()
	{
		loadGraphic("assets/images/goblin1.png", true, 8, 8);
		animation.add("main", [0, 1], 4, true);
		setGraphicSize(20, 20);
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
	}

	private function getScore()
	{
		return 1;
	}

	private function getTargetY()
	{
		return 197;
	}

	private function getUnitTag()
	{
		return "goblin";
	}
}