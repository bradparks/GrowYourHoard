package;

import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;
import nape.space.Space;
import nape.geom.Vec2;
import flixel.util.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;

/**
 * ...
 * @author John Doughty
 */
class ShowHoardState extends FlxNapeState
{

	var score:Int = 0;
	var subHead:FlxText;
	var head:FlxText;
	var scoreText:FlxText;
	var buyBtn:Button;
	override public function create():Void 
	{
		super.create();
		add(new FlxSprite(0, 0, AssetPaths.menubackground__png));
		FlxNapeState.space.gravity.setxy(0, 500);
		subHead = new FlxText(0, 0, 320);
		subHead.text = "GROW YOUR";
		subHead.setFormat(AssetPaths.Our_Arcade_Games__ttf, 20, FlxColor.GOLDEN, "center");
		subHead.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		add(subHead);
		
		head = new FlxText(0, 35, 320);
		head.text = "HOARD";
		head.setFormat(AssetPaths.Our_Arcade_Games__ttf, 20, FlxColor.GOLDEN, "center");
		head.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		head.scale.set(2, 2);
		add(head);
		scoreText = new FlxText(0, 100, 320);
		scoreText.text = "0 Gold";
		scoreText.setFormat(AssetPaths.Our_Arcade_Games__ttf, 20, FlxColor.GOLDEN, "center");
		scoreText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		add(scoreText);
		
		buyBtn = new Button(25, 155, 275, 80, AssetPaths.button__png, "Invest in Minions", buy,30);
		add(buyBtn);
	}
	
	public function buy(sprite:FlxSprite)
	{
		FlxG.switchState(new HoardState());
	}
	
	override public function update():Void 
	{
		super.update();
		if (score < Reg.score)
		{
			score++;
			scoreText.text = score+" Gold";
			new Coin(150 + FlxRandom.intRanged( -20, 20), -100);
		}
	}
	
}