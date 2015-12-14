package;

import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxG;
import flixel.FlxObject;
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
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxNapeState
{
	private var background:FlxSprite;
	private var castle:FlxSprite;
	private var scoreText:FlxText;
	private var greedCountText:FlxText;
	private var ogreCountText:FlxText;
	private var shieldCountText:FlxText;
	private var spawnTimer:Timer;
	private var soldierTimer:Timer;
	private var shootTimer:Timer;
	private var levelTimer:Timer;
	private var player:PlayerGroup;
	private var lastScore:Int;
	private var soldier:Soldier;

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
		
		castle = new FlxSprite(250, 57, AssetPaths.castle__png);
		castle.moves = false;
		castle.solid = false;
		add(castle);

		player = new PlayerGroup(60, 186);
		add(player);

		createUnitCounts();
		
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
		if (Reg.level > 3)
		{
			soldierTimer = new Timer(Math.round(Math.random() * 15000 + 5000));
			soldierTimer.run = spawnSoldier;
		}
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

		if (soldier != null)
		{
			if (soldier.x > 250 - soldier.width)
			{
				endLevel();
				return;
			}
			FlxG.overlap(soldier, Goblin.goblins, handleSoldierCollision);
			FlxG.overlap(soldier.hitBox, player.goblin, hitSoldier);
		}
		if (FlxG.keys.justPressed.G)
		{
			napeDebugEnabled = !napeDebugEnabled;
		}
		updateUnitCounts();
	}

	private function handleSoldierCollision(soldier:FlxSprite, goblin:FlxSprite)
	{
		goblin.hurt(5);
		FlxG.sound.play(AssetPaths.hit__wav);
	}

	private function hitSoldier(soldierHitBox:FlxSprite, goblin:FlxSprite)
	{
		if (player.dashing && !player.hasHit)
		{
			soldier.hurt(player.damage);
			player.hasHit = true;
			FlxG.sound.play(AssetPaths.hit__wav);
		}
	}

	private function handlePlayerCollision(projectile:NapeProjectile, goblin:FlxSprite)
	{
		projectile.stop(goblin.x + 2, goblin.x + goblin.width - 8, true);

		var sourceRect:Rectangle = new Rectangle(0, 0, projectile.spawnedArrow.width, projectile.spawnedArrow.height);
		var destPoint:Point = new Point(Std.int(projectile.spawnedArrow.x - player.projectilesInShield.x), player.projectilesInShield.height - projectile.spawnedArrow.height);

		if (player.goblin.flipX)
		{
			destPoint.x = player.projectilesInShield.width - destPoint.x - 8;
		}

		projectile.spawnedArrow.flipX = player.goblin.flipX;

		player.projectilesInShield.pixels.copyPixels(projectile.spawnedArrow.getFlxFrameBitmapData(), sourceRect, destPoint, null, null, true);
		player.projectilesInShield.frame.destroyBitmapDatas();
		player.projectilesInShield.dirty = true;

		projectile.countUpBlocked();
		projectile.spawnedArrow.kill();

		// Keep the player group on top
		remove(player, true);
		add(player);
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

	private function spawnSoldier()
	{
		soldierTimer.stop();
		soldierTimer = null;
		soldier = new Soldier( -58, 166);
		add(soldier);
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


		if (Reg.score >= 100)
		{
			FlxG.switchState(new WinState());
		}
		else
		{
			FlxG.switchState(new ShowHoardState());
		}
	}
	
	
	private function updateUnitCounts()
	{
		ogreCountText.text = Reg.upgrades["ogre"]["number"]+"";
		greedCountText.text = Reg.upgrades["greedy_goblin"]["number"]+"";
	}
	
	private function createUnitCounts()
	{
		add(new FlxSprite(0, 0,AssetPaths.shieldui__png));
		shieldCountText = new FlxText(16, 0, 32);
		shieldCountText.text = Reg.upgrades["large_shield"]["number"]+"";
		shieldCountText.setFormat(AssetPaths.Our_Arcade_Games__ttf, 12, FlxColor.GOLDEN, "left");
		shieldCountText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		add(shieldCountText);
		
		add(new GreedyGoblinUI(0, 18));
		greedCountText = new FlxText(16, 18, 32);
		greedCountText.text = Reg.upgrades["greedy_goblin"]["number"]+"";
		greedCountText.setFormat(AssetPaths.Our_Arcade_Games__ttf, 12, FlxColor.GOLDEN, "left");
		greedCountText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		add(greedCountText);
		
		add(new OgreUI(4, 36));
		ogreCountText = new FlxText(16, 36, 32);
		ogreCountText.text = Reg.upgrades["ogre"]["number"]+"";
		ogreCountText.setFormat(AssetPaths.Our_Arcade_Games__ttf, 12, FlxColor.GOLDEN, "left");
		ogreCountText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		add(ogreCountText);
	}
}