package;

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
		loadGraphic("assets/images/shield.png", 8, 16);
		animation.add("main",[0,1],4,true);
		setGraphicSize(20, 40);
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (FlxG.keys.anyJustPressed(["A","D"]))
		{
			animation.play("main");
		}
		else if (!FlxG.keys.anyPressed(["A", "D"]))
		{
			animation.frameIndex = 0;
			animation.pause();
		}
		
		if (FlxG.keys.pressed.A)
		{
			x -= 2;
		}
		if (FlxG.keys.pressed.D)
		{
			x += 2;
		}
		
	}
	
}