package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;

/**
 * ...
 * @author John Doughty
 */
class Player extends FlxSprite
{
	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y);

		allowCollisions = FlxObject.CEILING;
		immovable = true;
		loadGraphic("assets/images/shield.png",true, 8, 16);
		animation.add("main",[0,1],4,true);
		setGraphicSize(20, 40);
	}

	override public function update():Void
	{
		super.update();

		if (FlxG.keys.anyJustPressed(["A","D","LEFT","RIGHT"]) || FlxG.mouse.justPressed || FlxG.mouse.justPressedRight)
		{
			animation.play("main");
		}
		else if (!(FlxG.keys.anyPressed(["A", "D"]) || FlxG.mouse.pressed || FlxG.mouse.pressedRight))
		{
			animation.frameIndex = 0;
			animation.pause();
		}

		if (FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT || FlxG.mouse.pressed)
		{
			flipX = true;
			x -= 2;
		}
		if (FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT || FlxG.mouse.pressedRight)
		{
			flipX = false;
			x += 2;
		}
	}
}