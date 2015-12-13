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
	
	private static var doubleTapDirection:String = "left";
	private static var doubleTapDuration:Float = 0.0;
	
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

		var deltaX:Int = 0;
		var oldFlipX = goblin.flipX;

		if (!hasAnyInput())
		{
			goblin.animation.frameIndex = 0;
			goblin.animation.pause();
		}

		if (hasLeftInput())
		{
			goblin.flipX = true;
			deltaX = -2;
		}

		if (hasRightInput())
		{
			goblin.flipX = false;
			deltaX = 2;
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
	
	private function hasLeftInput()
	{
		return FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT || FlxG.mouse.pressed;
	}

	private function hasRightInput()
	{
		return FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT || FlxG.mouse.pressedRight;
	}
	
	private function hasAnyInput()
	{
		return FlxG.keys.anyPressed(["A", "D", "LEFT", "RIGHT"]) || FlxG.mouse.pressed || FlxG.mouse.pressedRight;
	}
}