package;

import openfl.display.BitmapData;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup;
import projectiles.Arrow;
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
	public var damage = 1;

	private var shieldOffsetX:Int = 5;
	private var shieldOffsetY:Int = 7;

	private var doubleTapDuration:Float = 0.0;
	private var doubleTapDirection:String = "";

	private var dashtimer:Timer;
	public var dashing:Bool;
	public var hasHit:Bool = false;

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
			goblin.loadGraphic("assets/images/shieldbigger.png", true, 30, 25);
			damage = 2;

			shieldOffsetX = 13;
		}
		else
		{
			goblin.loadGraphic("assets/images/shield.png", true, 20, 25);
		}

		goblin.animation.add("main", [0,1,2,1], 12, true);
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

		if (goblin.x > 250 - goblin.width + 8)
		{
			goblin.x = 250 - goblin.width + 8;
		}
		
		if (goblin.x < -goblin.width)
		{
			goblin.x = -goblin.width;
		}
		
		if (!processLeft && !processRight)
		{
			goblin.animation.frameIndex = 0;
			goblin.animation.pause();
			updateArrowsOnShield();
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
			goblin.animation.frameIndex = 3;
		}

		updateArrowsOnShield();
	}

	private function updateArrowsOnShield()
	{
		// Put arrows on top
		if (!dashing)
		{
			resetShieldProjectiles();
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
		hasHit = false;
		dashtimer.stop();
		dashtimer = null;
		goblin.allowCollisions = FlxObject.CEILING;

		resetShieldProjectiles();
	}

	private function resetShieldProjectiles()
	{
		projectilesInShield.angle = 0;
		projectilesInShield.x = goblin.x;
		projectilesInShield.y = goblin.y - projectilesInShield.height;
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
		var left:Int = 0;
		var right:Int = 0;

		if (doubleTapDuration > 0.1)
		{
			resetDoubleTap();
		}

		if (doubleTapDirection != "")
		{
			doubleTapDuration += FlxG.elapsed;
		}
		#if !FLX_NO_KEYBOARD
		if (FlxG.keys.anyJustPressed(keyboardInputs["left"]))
		{
			left++;
		}
		else if (FlxG.keys.anyJustPressed(keyboardInputs["right"]))
		{
			right++;
		}
		#end
		#if !FLX_NO_MOUSE
		if (FlxG.mouse.justPressed)
		{
			left++;
		}
		else if (FlxG.mouse.justPressedRight)
		{
			right++;
		}
		#end
		#if !FLX_NO_TOUCH
		for (touch in FlxG.touches.list)
		{
			if (touch.x <= FlxG.width / 2 && touch.justPressed)
			{
				left++;
			} 
			else if (touch.justPressed)
			{
				right++;
			}
		}
		#end
		if (left>right)
		{
			deltaX = processDoubleTapInput("left", -50);
		}
		else if (left<right)
		{
			deltaX = processDoubleTapInput("right", 50);
		}
		return deltaX;
	}

	private function hasLeftInput()
	{
		var result:Bool = false;
		var touched:Bool = false;
		#if !FLX_NO_KEYBOARD
		result = FlxG.keys.anyPressed(keyboardInputs["left"]);
		#end
		#if !FLX_NO_TOUCH
		for (touch in FlxG.touches.list)
		{
			if (touch.pressed)
			{
				touched = true;
				if (touch.x <= FlxG.width / 2 && touch.pressed)
				{
					result = true;
				}
			}
		}
		#end
		#if !FLX_NO_MOUSE
		if(!result && !touched)
		{
			result = FlxG.mouse.pressed;
		}
		#end
		return result;
	}

	private function hasRightInput()
	{
		var result:Bool = false;
		var touched:Bool = false;
		#if !FLX_NO_KEYBOARD
		result = FlxG.keys.anyPressed(keyboardInputs["right"]);
		#end
		#if !FLX_NO_TOUCH
		for (touch in FlxG.touches.list)
		{
			if (touch.pressed)
			{
				touched = true;
				if (touch.x > FlxG.width / 2 && touch.pressed)
				{
					result = true;
				}
			}
		}
		#end
		#if !FLX_NO_MOUSE
		if(!result && !touched)
		{
			result = FlxG.mouse.pressedRight;
		}
		#end
		return result;
	}
}