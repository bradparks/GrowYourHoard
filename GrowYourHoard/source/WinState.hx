package;

import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;
import flixel.group.FlxGroup;
import nape.space.Space;
import nape.geom.Vec2;
import flixel.util.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;

class WinState extends FlxNapeState
{
	var score:Int = 0;
	var subHead:FlxText;
	var head:FlxText;
	var scoreText:FlxText;
	var menuBtn:Button;
	var creditsBtn:Button;
	var goblinSurvivors:Int;
	var greedyGoblinSurvivors:Int;
	var ogreSurvivors:Int;

	override public function create():Void
	{
		super.create();
		
		goblinSurvivors = Reg.counters["goblins_launched"] - Reg.counters["goblins_harmed"];
		greedyGoblinSurvivors = Reg.counters["greedy_goblins_launched"] - Reg.counters["greedy_goblins_harmed"];
		ogreSurvivors = Reg.counters["ogres_launched"] - Reg.counters["ogres_harmed"];
		
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

		scoreText = new FlxText(0, 73, 320);
		scoreText.text = "0 Gold";
		scoreText.setFormat(AssetPaths.Our_Arcade_Games__ttf, 20, FlxColor.GOLDEN, "center");
		scoreText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		add(scoreText);

		menuBtn = new Button(7, 180, 150, 50, AssetPaths.button__png, "Menu", menu, 27);
		add(menuBtn);

		creditsBtn = new Button(165, 180, 150, 50, AssetPaths.button__png, "Credits", credits, 27);
		add(creditsBtn);

		createWalls(0, -125, 320, 175);
	}

	public function menu(sprite:FlxSprite)
	{
		FlxG.switchState(new MenuState());
	}

	public function credits(sprite:FlxSprite)
	{
		FlxG.switchState(new CreditsState());
	}

	override public function update():Void
	{
		super.update();

		if (FlxRandom.chanceRoll(1) && ogreSurvivors > 0)
		{
			ogreSurvivors -= 1;
			add(new OgreShow(270, 112));
		}
		
		if (FlxRandom.chanceRoll(1) && goblinSurvivors > 0)
		{
			goblinSurvivors -= 1;
			add(new GoblinShow(270, 140));
		}

		if (FlxRandom.chanceRoll(1) && greedyGoblinSurvivors > 0)
		{
			greedyGoblinSurvivors -= 1;
			add(new GreedyGoblinShow(270, 140));
		}


		if (score < Reg.score)
		{
			score++;
			scoreText.text = score + " Gold";
			//repl
			if (score <= 50)
			{
				new Coin(150 + FlxRandom.intRanged(-20, 20), -100);
			}
		}
	}
}