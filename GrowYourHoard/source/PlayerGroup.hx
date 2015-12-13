package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup;
import Arrow;

/**
 * ...
 * @author John Doughty
 */
class PlayerGroup extends FlxGroup
{
	public var goblin:FlxSprite;
	public var arrows:Array<Arrow> = [];

	public function new(X:Float=0, Y:Float=0)
	{
		super();
		goblin = new FlxSprite(X, Y);
		goblin.allowCollisions = FlxObject.CEILING;
		goblin.immovable = true;

		if (Reg.upgrades["large_shield"]["number"] > 0)
		{
			Reg.upgrades["large_shield"]["number"] -= 1;
			goblin.loadGraphic("assets/images/shieldbigger.png", true, 12, 16);
			goblin.setGraphicSize(30, 40);
		}
		else
		{
			goblin.loadGraphic("assets/images/shield.png", true, 8, 16);
			goblin.setGraphicSize(20, 40);
		}

		goblin.animation.add("main", [0,1], 4, true);

		add(goblin);
	}

	override public function update():Void
	{
		super.update();
		var i:Int;
		if (!(FlxG.keys.anyPressed(["A", "D"]) || FlxG.mouse.pressed || FlxG.mouse.pressedRight))
		{
			goblin.animation.frameIndex = 0;
			goblin.animation.pause();
		}
		if (FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT || FlxG.mouse.pressed)
		{
			goblin.animation.play("main");
			goblin.flipX = true;
			goblin.x -= 2;
			for (i in 0...arrows.length)
			{
				arrows[i].x -= 2;
			}
		}
		if (FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT || FlxG.mouse.pressedRight)
		{
			goblin.animation.play("main");
			goblin.flipX = false;
			goblin.x += 2;
			for (i in 0...arrows.length)
			{
				arrows[i].x += 2;
			}
		}
	}
}