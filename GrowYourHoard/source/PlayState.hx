package;

import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import haxe.Timer;
import nape.space.Space;
import nape.geom.Vec2;
import flixel.addons.nape.FlxNapeState;
import flixel.util.FlxRandom;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxNapeState
{
	private var background:FlxSprite;
	private var castle:FlxSprite;
	private var fire:FlxSprite;
	private var scoreText:FlxText;
	private var spawnTimer:Timer;
	private var shootTimer:Timer;
	private var levelTimer:Timer;
	private var player:PlayerGroup;
	private var lastScore:Int;

	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();

		Goblin.goblins = new FlxGroup();
		NapeProjectile.projectiles = new FlxGroup();
		NapeProjectile.deadProjectiles = new FlxGroup();
		NapeArrow.arrows = new FlxGroup();
		NapeAxe.axes = new FlxGroup();

		FlxG.mouse.visible = false;

		background = new FlxSprite(0, 0, AssetPaths.background__png);
		background.moves = false;
		background.solid = false;
		add(background);

		fire = new FlxSprite(255, 30);
		fire.loadGraphic(AssetPaths.fire__png, true, 68, 80);
		fire.animation.add("main", [0, 1, 2], 10);
		fire.animation.play("main");
		add(fire);
		
		castle = new FlxSprite(250, 57, AssetPaths.castle__png);
		castle.moves = false;
		castle.solid = false;
		add(castle);

		player = new PlayerGroup(60, 186);
		add(player);

		scoreText = new FlxText(0, 0, 320);
		scoreText.text = Reg.score+"";
		scoreText.setFormat(AssetPaths.Our_Arcade_Games__ttf, 20, FlxColor.GOLDEN, "center");
		scoreText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		add(scoreText);

		//Keeps mass created units from updating at the exact same time. Idea from: http://answers.unity3d.com/questions/419786/a-pathfinding-multiple-enemies-MOVING-target-effic.html
		spawnTimer = new Timer(Math.floor(2000 * FlxRandom.floatRanged(.25*(100-Reg.level*2/100)/100,1*(100-Reg.level*2/100)/100)));
		spawnTimer.run = spawn;

		spawn();

		//Keeps mass created units from updating at the exact same time. Idea from: http://answers.unity3d.com/questions/419786/a-pathfinding-multiple-enemies-MOVING-target-effic.html
		shootTimer = new Timer(Math.floor(1000 * FlxRandom.floatRanged(.25*(100-Reg.level*2/100)/100,1*(100-Reg.level*2/100)/100)));
		shootTimer.run = shoot;


		FlxNapeState.space.gravity.setxy(0, 500);

		Reg.level += 1;
		levelTimer = new Timer((30 + Reg.level) * 1000);
		levelTimer.run = endLevel;
	}

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		if (Reg.score+"" != scoreText.text)
		{
			scoreText.text = Reg.score+"";
			FlxG.sound.play(AssetPaths.coin__wav);
		}
		FlxG.collide(NapeProjectile.projectiles, player.goblin, handlePlayerCollision);
		FlxG.collide(NapeProjectile.projectiles, Goblin.goblins, handleGoblinCollision);

		if (FlxG.keys.justPressed.G)
		{
			napeDebugEnabled = !napeDebugEnabled;
		}
	}

	private function handlePlayerCollision(projectile:NapeProjectile, goblin:FlxSprite)
	{
		projectile.stop();
		player.arrows.push(projectile.spawnedArrow);
		projectile.countUpBlocked();
	}

	private function handleGoblinCollision(projectile:NapeProjectile, goblin:Goblin)
	{
		goblin.hurt(projectile.damage);
		projectile.destroy();
		FlxG.sound.play(AssetPaths.hit__wav);
	}

	private function spawn()
	{
		spawnTimer.stop();
		spawnTimer = new Timer(Math.floor(2000 * FlxRandom.floatRanged(.25*(100-Reg.level*2/100)/100,1*(100-Reg.level*2/100)/100)));
		spawnTimer.run = spawn;

		if (Reg.upgrades["greedy_goblin"]["number"] > 0 && Math.random() > 0.8)
		{
			Goblin.goblins.add(new GreedyGoblin(260, 197));
		}
		else if (Reg.upgrades["ogre"]["number"] > 0 && Math.random() > 0.8)
		{
			Goblin.goblins.add(new Ogre(260, 170));
		}
		else
		{
			Goblin.goblins.add(new Goblin(260, 197));
		}

		add(Goblin.goblins);
	}

	private function shoot()
	{
		shootTimer.stop();
		shootTimer = new Timer(Math.floor(1000 * FlxRandom.floatRanged(.25*(100-Reg.level*2/100)/100,1*(100-Reg.level*2/100)/100)));
		shootTimer.run = shoot;
		if (Math.random() > .1 + Reg.level/30)
		{
			NapeArrow.arrows.add(new NapeArrow(250, 70));
			add(NapeArrow.arrows);
			FlxG.sound.play(AssetPaths.arrowshoot__wav);
		}
		else
		{
			NapeAxe.axes.add(new NapeAxe(250, 70));
			add(NapeAxe.axes);
			FlxG.sound.play(AssetPaths.arrowshoot__wav);
		}
	}

	private function endLevel()
	{
		Goblin.goblins.destroy();
		NapeProjectile.projectiles.destroy();
		NapeProjectile.deadProjectiles.destroy();

		spawnTimer.stop();
		shootTimer.stop();
		levelTimer.stop();

		FlxG.mouse.visible = true;

		FlxG.switchState(new HoardState());
	}
}