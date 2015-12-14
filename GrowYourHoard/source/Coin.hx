package;

import flixel.addons.nape.FlxNapeSprite;
import nape.geom.Vec2;
import flixel.util.FlxRandom;
import flixel.FlxG;

/**
 * ...
 * @author John Doughty
 */
class Coin extends FlxNapeSprite
{

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.coin__png, true, 8, 8);
		animation.add("main", [4, 5, 6, 7], 10, true);
		animation.play("main");		
		solid = true;
		antialiasing = true;
		createRectangularBody();
		setBodyMaterial();
        
		body.shapes.at(0).material.density = .5;
		body.applyImpulse(new Vec2(FlxRandom.floatRanged(-.5, .5), FlxRandom.floatRanged(0, 5)));
	
		FlxG.state.add(this);
	}
	
	override public function update():Void 
	{
		super.update();
		if (y > 240)
		{
			kill();
		}
	}
}