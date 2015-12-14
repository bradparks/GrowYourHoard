package;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxVelocity;
import flixel.util.FlxPoint;
import flixel.FlxG;

/**
 * ...
 * @author John Doughty
 */
class Soldier extends FlxSprite
{
	public var hitBox:FlxSprite;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.soldier__png, true, 32, 20);
		setGraphicSize(72, 45);
		updateHitbox();
		animation.add("attack", [0, 1], 4, true);
		animation.add("main", [2, 3, 4, 5, 6, 5, 4, 3], 4,true);
		animation.play("main");
		hitBox = new FlxSprite(X, Y+16);
		hitBox.width = 27;
		hitBox.height = 45;
		hitBox.updateHitbox();
		
		FlxG.state.add(hitBox);
		
		FlxVelocity.moveTowardsPoint(this, new FlxPoint(320, y), 10);
	
	}

	override public function update():Void
	{
		super.update();
		hitBox.x = x;
		this.y = getTargetY();
	}

	private function getTargetY()
	{
		return 166;
	}
	
}