package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup;

/**
 * ...
 * @author John Doughty
 */
class PlayerGroup extends FlxGroup
{
	var goblin:FlxSprite;
	public function new(X:Float=0, Y:Float=0)
	{
		super();
		goblin = new FlxSprite(X, Y);
		goblin.allowCollisions = FlxObject.CEILING;
		goblin.immovable = true;
		goblin.loadGraphic("assets/images/shield.png",true, 8, 16);
		goblin.animation.add("main",[0,1],4,true);
		goblin.setGraphicSize(20, 40);
		add(goblin);
	}

	override public function update():Void
	{
		super.update();

		if (FlxG.keys.anyJustPressed(["A","D","LEFT","RIGHT"]) || FlxG.mouse.justPressed || FlxG.mouse.justPressedRight)
		{
			goblin.animation.play("main");
		}
		else if (!(FlxG.keys.anyPressed(["A", "D"]) || FlxG.mouse.pressed || FlxG.mouse.pressedRight))
		{
			goblin.animation.frameIndex = 0;
			goblin.animation.pause();
		}

		if (FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT || FlxG.mouse.pressed)
		{
			goblin.flipX = true;
			goblin.x -= 2;
		}
		if (FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT || FlxG.mouse.pressedRight)
		{
			goblin.flipX = false;
			goblin.x += 2;
		}
	}
}