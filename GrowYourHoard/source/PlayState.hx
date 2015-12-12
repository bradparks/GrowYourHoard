package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public static var score:Int = 0;
	
	private var background:FlxSprite;
	private var castle:FlxSprite;
	private var scoreText:FlxText;
	
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();
		
		background = new FlxSprite(0, 0, "assets/images/background.png");
		castle = new FlxSprite(250, 32, "assets/images/castle.png");
		
		add(background);
		add(castle);
		add(new Goblin(260, 172));
		add(new Player(60, 157));
		scoreText = new FlxText(0, 0, 320); // x, y, width
		scoreText.text = score+"";
		scoreText.setFormat("assets/fonts/Our-Arcade-Games.ttf", 20, FlxColor.WHITE, "center");
		scoreText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.RED, 1);
		add(scoreText);
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
	}
}