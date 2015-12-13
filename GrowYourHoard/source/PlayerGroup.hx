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
	public var arrows:Array<FlxSprite> = [];

	private var doubleTapDuration:Float = 0.0;
	private var doubleTapDirection:String = "";
	private var keyboardInputs = [
		"left" => [
			"A",
			"LEFT"
		],
		"right" => [
			"D",
			"RIGHT"
		]
	];

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

		var processLeft:Bool = hasLeftInput();
		var processRight:Bool = hasRightInput();

		if (!processLeft && !processRight)
		{
			goblin.animation.frameIndex = 0;
			goblin.animation.pause();
			return;
		}

		var deltaX:Int = performDoubleTap();
		var oldFlipX = goblin.flipX;

		if (processLeft)
		{
			goblin.flipX = true;
			deltaX += -2;
		}

		if (processRight)
		{
			goblin.flipX = false;
			deltaX += 2;
		}

		if (deltaX != 0)
		{
			goblin.animation.play("main");
			goblin.x += deltaX;

			var flipArrows:Bool = (goblin.flipX != oldFlipX);
			var i:Int;

			for (i in 0...arrows.length)
			{
				arrows[i].x += deltaX;
				if (flipArrows)
				{
					arrows[i].flipX = !arrows[i].flipX;
				}
			}
		}
	}

	private function resetDoubleTap(direction:String = "")
	{
		doubleTapDuration = 0.0;
		doubleTapDirection = direction;
	}

	private function processDoubleTapInput(direction:String, possibleDeltaX:Int)
	{
		var deltaX:Int = 0;

		if (doubleTapDirection == direction)
		{
			deltaX = possibleDeltaX;
			resetDoubleTap();
		}
		else
		{
			resetDoubleTap(direction);
		}

		return deltaX;
	}

	private function performDoubleTap()
	{
		var deltaX:Int = 0;

		if (doubleTapDuration > 0.1)
		{
			resetDoubleTap();
		}

		if (doubleTapDirection != "")
		{
			doubleTapDuration += FlxG.elapsed;
		}

		if (FlxG.keys.anyJustPressed(keyboardInputs["left"]) || FlxG.mouse.justPressed)
		{
			deltaX = processDoubleTapInput("left", -50);
		}
		else if (FlxG.keys.anyJustPressed(keyboardInputs["right"]) || FlxG.mouse.justPressedRight)
		{
			deltaX = processDoubleTapInput("right", 50);
		}

		return deltaX;
	}

	private function hasLeftInput()
	{
		return FlxG.keys.anyPressed(keyboardInputs["left"]) || FlxG.mouse.pressed;
	}

	private function hasRightInput()
	{
		return FlxG.keys.anyPressed(keyboardInputs["right"]) || FlxG.mouse.pressedRight;
	}
}