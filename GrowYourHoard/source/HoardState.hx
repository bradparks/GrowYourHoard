package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.plugin.MouseEventManager;

/**
 * A FlxState which can be used for the game's menu.
 */
class HoardState extends FlxState
{
	private var subHead:FlxText;
	private var head:FlxText;
	private var scoreText:FlxText;
	private var menuButtons:FlxGroup;

	private static var buttons = [
		"NEXT LEVEL" => [
			"x"        => 40,
			"y"        => 200,
			"width"    => 240,
			"height"   => 30,
			"callback" => 0
		],
		"OGRE" => [
			"x"        => 40,
			"y"        => 155,
			"width"    => 240,
			"height"   => 30,
			"callback" => 1
		],
		"GREEDY GOBLIN" => [
			"x"        => 40,
			"y"        => 120,
			"width"    => 240,
			"height"   => 30,
			"callback" => 2
		],
		"LARGE SHIELD" => [
			"x"        => 40,
			"y"        => 85,
			"width"    => 240,
			"height"   => 30,
			"callback" => 3
		]
	];

	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();

		menuButtons = new FlxGroup();

		add(new FlxSprite(0, 0, AssetPaths.menubackground__png));

		subHead = new FlxText(0, 0, 320);
		subHead.text = "GROW YOUR";
		subHead.setFormat(AssetPaths.Our_Arcade_Games__ttf, 20, FlxColor.GOLDEN, "center");
		subHead.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		add(subHead);
		
		scoreText = new FlxText(235, 40, 50);
		scoreText.text = Reg.score+"";
		scoreText.setFormat(AssetPaths.Our_Arcade_Games__ttf, 20, FlxColor.GOLDEN, "center");
		scoreText.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		add(scoreText);

		head = new FlxText(0, 35, 320);
		head.text = "HOARD";
		head.setFormat(AssetPaths.Our_Arcade_Games__ttf, 20, FlxColor.GOLDEN, "center");
		head.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		head.scale.set(2, 2);
		add(head);

		createButtons();
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
	}

	private function buy(itemOrUnitName:String)
	{
		if (Reg.score >= Reg.upgrades[itemOrUnitName]["cost"])
		{
			Reg.score -= Reg.upgrades[itemOrUnitName]["cost"];
			Reg.upgrades[itemOrUnitName]["number"] += 1;
		}
	}

	private function play(sprite:FlxSprite = null)
	{
		FlxG.switchState(new PlayState());
	}

	private function buyOgre(sprite:FlxSprite = null)
	{
		buy("ogre");
	}

	private function buyGreedyGoblin(sprite:FlxSprite = null)
	{
		buy("greedy_goblin");
	}

	private function buyShield(sprite:FlxSprite = null)
	{
		buy("large_shield");
	}

	private function createButtons()
	{
		var callbacks = [
			play,
			buyOgre,
			buyGreedyGoblin,
			buyShield
		];
		var callbacksWorth = [
			"",
			"1",
			"1",
			"5"
		];

		for (buttonName in buttons.keys())
		{
			var button:Button = new Button(buttons[buttonName]["x"],
										   buttons[buttonName]["y"],
										   buttons[buttonName]["width"],
										   buttons[buttonName]["height"],
										   AssetPaths.button__png,
										   buttonName+" " + callbacksWorth[buttons[buttonName]["callback"]],
										   callbacks[buttons[buttonName]["callback"]]);

			menuButtons.add(button);

		}

		add(menuButtons);
	}
}