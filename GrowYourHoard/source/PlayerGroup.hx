package;

import openfl.display.BitmapData;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup;
import Arrow;
import flixel.tweens.FlxTween;
import haxe.Timer;

/**
 * ...
 * @author John Doughty
 */
class PlayerGroup extends FlxGroup
{
	public var goblin:FlxSprite;
	public var projectilesInShield:FlxSprite;

	private var shieldOffsetX:Int = 5;
	private var shieldOffsetY:Int = 7;

	private var doubleTapDuration:Float = 0.0;
	private var doubleTapDirection:String = "";

	private var dashtimer:Timer;
	private var dashing:Bool;

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
			goblin.loadGraphic("assets/images/shieldbigger.png", true, 12, 10);
			goblin.setGraphicSize(30, 25);
			goblin.updateHitbox();

			shieldOffsetX = 13;
		}
		else
		{
			goblin.loadGraphic("assets/images/shield.png", true, 8, 10);
			goblin.setGraphicSize(20, 25);
			goblin.updateHitbox();
		}

		goblin.animation.add("main", [0,1], 4, true);
		add(goblin);

		projectilesInShield = new FlxSprite();
		projectilesInShield.pixels = new BitmapData(Std.int(goblin.width), 10, true, 0xFFFFFF);
		add(projectilesInShield);
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
			projectilesInShield.flipX = true;
			goblin.flipX = true;
			deltaX += -2;
		}

		if (processRight)
		{
			projectilesInShield.flipX = false;
			goblin.flipX = false;
			deltaX += 2;
		}

		if (!dashing)
		{
			if (deltaX != 0 && Math.abs(deltaX) < 3)
			{
				goblin.animation.play("main");
				goblin.x += deltaX;
			}
			else if (Math.abs(deltaX) > 2)
			{
				FlxTween.tween(goblin, { x: goblin.x + deltaX }, .2);
				dashing = true;
				dashtimer = new Timer(200);
				dashtimer.run = clearDashing;

				if (goblin.flipX)
				{
					goblin.allowCollisions = FlxObject.LEFT;
				}
				else
				{
					goblin.allowCollisions = FlxObject.RIGHT;
				}
			}
		}
		else
		{
			goblin.animation.frameIndex = 2;
		}

		updateArrowsOnShield();
	}

	private function updateArrowsOnShield()
	{
		// Put arrows on top
		if (!dashing)
		{
			projectilesInShield.angle = 0;
			projectilesInShield.x = goblin.x;
			projectilesInShield.y = goblin.y - projectilesInShield.height;
		}
		else
		{
			// Put arrows on the side left side
			if (goblin.flipX)
			{
				projectilesInShield.angle = 270;
				projectilesInShield.x = goblin.x - projectilesInShield.width + shieldOffsetX;
			}
			else
			{
				projectilesInShield.angle = 90;
				projectilesInShield.x = goblin.x + goblin.width - shieldOffsetX;
			}

			projectilesInShield.y = goblin.y + shieldOffsetY;
		}
	}

	private function clearDashing()
	{
		dashing = false;
		dashtimer.stop();
		dashtimer = null;
		goblin.allowCollisions = FlxObject.CEILING;
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