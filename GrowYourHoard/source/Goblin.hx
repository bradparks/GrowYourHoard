package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

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

		loadGraphic("assets/images/goblin1.png", true, 8, 8);
		animation.add("main", [0, 1], 4, true);
		setGraphicSize(20, 20);
		flipX = true;
		animation.play("main");
	}

	override public function update():Void
	{
		super.update();
		this.x -= 1;
		if (this.x < 0 - width)
		{
			Reg.score += 1;
			kill();
		}
	}

	override public function kill():Void
	{
		super.kill();
		Goblin.goblins.remove(this, true);
		destroy();
	}
}