package projectiles;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import projectiles.Axe;

/**
 * ...
 * @author John Doughty
 */
class NapeAxe extends NapeProjectile
{
	public static var axes:FlxGroup =  null;

	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y);
		damage = 2;
		NapeProjectile.projectiles.add(axes);
	}

	override public function setupGraphics()
	{
		super.setupGraphics();
		loadGraphic(AssetPaths.axe__png, false, 8, 8);
		animation.add("main", [0, 1, 2, 3], 10, true);
		animation.play("main");
	}

	override public function countUpLaunched()
	{
		super.countUpLaunched();
		Reg.counters["axes_launched"] += 1;
	}

	override public function countUpBlocked()
	{
		super.countUpBlocked();
		Reg.counters["axes_blocked"] += 1;
	}

	override public function getSpawnedSprite(x:Float, y:Float):FlxSprite
	{
		return new projectiles.Axe(x, y);
	}
}