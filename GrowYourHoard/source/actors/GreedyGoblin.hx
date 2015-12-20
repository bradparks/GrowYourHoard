package actors;

import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.util.FlxVelocity;
import actors.Goblin;

class GreedyGoblin extends actors.Goblin
{
	public function new(X:Float=0, Y:Float=0, unitHealth:Float=1.0, ?SimpleGraphic:Dynamic)
	{
		super(X, Y, unitHealth, SimpleGraphic);
	}

	override public function update():Void
	{
		super.update();

		if (FlxRandom.chanceRoll(1))
		{
			moves = !moves;
			animation.play(moves ? "walking" : "stopped");
		}
	}

	override private function setup()
	{
		loadGraphic("assets/images/goblinbigbag.png", true, 20, 20);
		setGraphicSize(20, 20);
		updateHitbox();
		flipX = true;

		animation.add("walking", [0, 1, 2], 12, true);
		animation.add("stopped", [3, 4, 5], 12, true);
		animation.play("walking");

		Reg.counters["greedy_goblins_launched"] += 1;

		FlxVelocity.moveTowardsPoint(this, new FlxPoint(0 - width, y), 45);
	}

	override private function getScore()
	{
		return 3;
	}

	override private function getUnitTag()
	{
		return "greedy_goblin";
	}
}