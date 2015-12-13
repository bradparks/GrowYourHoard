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
	private var scoreText:FlxText;
	private var spawnTimer:Timer;
	private var shootTimer:Timer;
	private var levelTimer:Timer;
	private var player:PlayerGroup;

	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();

		Goblin.goblins = new FlxGroup();
		NapeArrow.arrows = new FlxGroup();
		Arrow.arrows = new FlxGroup();

		FlxG.mouse.visible = false;

		background = new FlxSprite(0, 0, "assets/images/background.png");
		background.moves = false;
		background.solid = false;
		add(background);

		castle = new FlxSprite(250, 32, "assets/images/castle.png");
		castle.moves = false;
		castle.solid = false;
		add(castle);

		player = new PlayerGroup(60, 157);
		add(player);

		scoreText = new FlxText(0, 0, 320);
		scoreText.text = Reg.score+"";
		scoreText.setFormat("assets/fonts/Our-Arcade-Games.ttf", 20, FlxColor.GOLDEN, "center");
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
		scoreText.text = Reg.score+"";

		FlxG.collide(NapeArrow.arrows, player.goblin, handlePlayerCollision);
		FlxG.collide(NapeArrow.arrows, Goblin.goblins, handleGoblinCollision);

		if (FlxG.keys.justPressed.G)
		{
			napeDebugEnabled = !napeDebugEnabled;
		}
	}

	private function handlePlayerCollision(arrow:NapeArrow, goblin:FlxSprite)
	{
		arrow.stop();
		player.arrows.push(arrow.spawnedArrow);
		arrow.spawnedArrow.y += 5;
		Reg.counters["arrows_blocked"] += 1;
	}

	private function handleGoblinCollision(arrow:NapeArrow, goblin:Goblin)
	{
		goblin.hurt(1.0);
		arrow.destroy();
	}

	private function spawn()
	{
		spawnTimer.stop();
		spawnTimer = new Timer(Math.floor(2000 * FlxRandom.floatRanged(.25*(100-Reg.level*2/100)/100,1*(100-Reg.level*2/100)/100)));
		spawnTimer.run = spawn;

		if (Reg.upgrades["greedy_goblin"]["number"] > 0)
		{
			Reg.upgrades["greedy_goblin"]["number"] -= 1;
			Goblin.goblins.add(new GreedyGoblin(260, 172));
		}
		else if (Reg.upgrades["ogre"]["number"] > 0)
		{
			Reg.upgrades["ogre"]["number"] -= 1;
			Goblin.goblins.add(new Ogre(260, 145));
		}
		else
		{
			Goblin.goblins.add(new Goblin(260, 172));
		}

		add(Goblin.goblins);
	}

	private function shoot()
	{
		shootTimer.stop();
		shootTimer = new Timer(Math.floor(1000 * FlxRandom.floatRanged(.25*(100-Reg.level*2/100)/100,1*(100-Reg.level*2/100)/100)));
		shootTimer.run = shoot;
		NapeArrow.arrows.add(new NapeArrow(250, 20));
		add(NapeArrow.arrows);
	}

	private function endLevel()
	{
		Goblin.goblins.destroy();
		NapeArrow.arrows.destroy();
		Arrow.arrows.destroy();

		spawnTimer.stop();
		shootTimer.stop();
		levelTimer.stop();

		FlxG.mouse.visible = true;

		FlxG.switchState(new HoardState());
	}
}