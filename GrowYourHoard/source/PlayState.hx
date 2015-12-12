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

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxNapeState
{
	private var background:FlxSprite;
	private var castle:FlxSprite;
	private var scoreText:FlxText;
	private var spawnTimer:Timer;
	private var levelTimer:Timer;
	private var player:Player;

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

		player = new Player(60, 157);
		add(player);

		scoreText = new FlxText(0, 0, 320);
		scoreText.text = Reg.score+"";
		scoreText.setFormat("assets/fonts/Our-Arcade-Games.ttf", 20, FlxColor.GOLDEN, "center");
		scoreText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		add(scoreText);

		//Keeps mass created units from updating at the exact same time. Idea from: http://answers.unity3d.com/questions/419786/a-pathfinding-multiple-enemies-MOVING-target-effic.html
		spawnTimer = new Timer(2000);
		spawnTimer.run = spawn;

		spawn();

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

		FlxG.collide(NapeArrow.arrows, player, handlePlayerCollision);
		FlxG.collide(NapeArrow.arrows, Goblin.goblins, handleGoblinCollision);

		if (FlxG.keys.justPressed.G)
		{
			napeDebugEnabled = !napeDebugEnabled;
		}
	}

	private function handlePlayerCollision(arrow:NapeArrow, player:Player)
	{
		arrow.stop();
	}

	private function handleGoblinCollision(arrow:NapeArrow, goblin:Goblin)
	{
		goblin.hurt(1.0);
		arrow.destroy();
	}

	private function spawn()
	{
		Goblin.goblins.add(new Goblin(260, 172));
		add(Goblin.goblins);

		NapeArrow.arrows.add(new NapeArrow(250, 20));
		add(NapeArrow.arrows);
	}

	private function endLevel()
	{
		Goblin.goblins.destroy();
		NapeArrow.arrows.destroy();
		Arrow.arrows.destroy();

		spawnTimer.stop();
		levelTimer.stop();

		FlxG.mouse.visible = true;

		FlxG.switchState(new HoardState());
	}
}