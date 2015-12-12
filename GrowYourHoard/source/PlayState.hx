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
	public static var score:Int = 0;

	private var background:FlxSprite;
	private var castle:FlxSprite;
	private var scoreText:FlxText;
	private var spawnTimer:Timer;
	private var player:Player;

	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();

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
		scoreText.text = score+"";
		scoreText.setFormat("assets/fonts/Our-Arcade-Games.ttf", 20, FlxColor.GOLDEN, "center");
		scoreText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		add(scoreText);

		//Keeps mass created units from updating at the exact same time. Idea from: http://answers.unity3d.com/questions/419786/a-pathfinding-multiple-enemies-MOVING-target-effic.html
		spawnTimer = new Timer(Math.floor(2000));
		spawnTimer.run = spawn;

		spawn();

		FlxNapeState.space.gravity.setxy(0, 500);
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
		scoreText.text = score+"";

		FlxG.collide(NapeArrow.arrows, player, handlePlayerCollision);

		if (FlxG.keys.justPressed.G)
		{
			napeDebugEnabled = !napeDebugEnabled;
		}
	}

	private function handlePlayerCollision(arrow:NapeArrow, player:Player)
	{
		var landedArrow:Arrow = new Arrow(arrow.x, arrow.y);
		add(landedArrow);
		Arrow.arrows.add(landedArrow);

		NapeArrow.arrows.remove(arrow, true);
		arrow.destroy();
	}

	private function spawn()
	{
		add(new Goblin(260, 172));

		var arrow:NapeArrow = new NapeArrow(250, 20);
		NapeArrow.arrows.add(arrow);
		add(arrow);
	}
}