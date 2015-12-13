package;
import flixel.group.FlxGroup;
import flixel.FlxSprite;

/**
 * ...
 * @author John Doughty
 */
class NapeArrow extends NapeProjectile
{
	public static var arrows:FlxGroup = null;
	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y);
		NapeProjectile.projectiles.add(arrows);
	}

	override public function setupGraphics()
	{
		super.setupGraphics();
		loadGraphic(AssetPaths.arrow__png, false, 8, 8);
	}

	override public function countUpLaunched()
	{
		super.countUpLaunched();
		Reg.counters["arrows_launched"] += 1;
	}

	override public function countUpBlocked()
	{
		super.countUpBlocked();
		Reg.counters["arrows_blocked"] += 1;
	}

	override public function getSpawnedSprite(x:Float,y:Float):FlxSprite
	{
		return new Arrow(x, y);
	}
}