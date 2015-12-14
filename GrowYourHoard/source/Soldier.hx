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
		loadGraphic(AssetPaths.soldier__png, true, 26, 20);
		setGraphicSize(58, 45);
		updateHitbox();
		animation.add("main", [0, 1, 2, 3, 4, 3, 2, 1], 4,true);
		animation.play("main");
		hitBox = new FlxSprite(X, Y);
		hitBox.loadGraphic(AssetPaths.background__png, false, 27, 45);
		hitBox.updateHitbox();
		hitBox.alpha = 0;
		//immovable = true;
		//allowCollisions = FlxObject.RIGHT;
		
		health = Reg.level;
		
		FlxG.state.add(hitBox);
		
		FlxVelocity.moveTowardsPoint(this, new FlxPoint(320, y), 20);
	
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