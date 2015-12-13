package;

import flixel.util.FlxPoint;
import flixel.util.FlxVelocity;

class GreedyGoblin extends Goblin
{
	public function new(X:Float=0, Y:Float=0, unitHealth:Float=1.0, ?SimpleGraphic:Dynamic)
	{
		super(X, Y, unitHealth, SimpleGraphic);
	}

	override function setup()
	{
		loadGraphic("assets/images/goblinbigbag.png", true, 8, 8);
		animation.add("main", [0, 1], 4, true);
		setGraphicSize(20, 20);
		flipX = true;
		animation.play("main");

		Reg.counters["greedy_goblins_launched"] += 1;

		FlxVelocity.moveTowardsPoint(this, new FlxPoint(0 - width, y), 30);
	}

	override public function update():Void
	{
		super.update();

		if (this.x < 0 - width)
		{
			Reg.score += 3;
			kill();
		}
	}
}