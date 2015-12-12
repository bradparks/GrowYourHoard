package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.plugin.MouseEventManager;

/**
 * A FlxState which can be used for the game's menu.
 */
class HoardState extends FlxState
{
	var subHead:FlxText;
	var head:FlxText;
	var playBtn:Button;
	var helpBtn:Button;
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();
		subHead = new FlxText(0, 0, 320);
		subHead.text = "GROW YOUR";
		subHead.setFormat("assets/fonts/Our-Arcade-Games.ttf", 20, FlxColor.GOLDEN, "center");
		subHead.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		head = new FlxText(0, 35, 320);
		head.text = "HOARD";
		head.setFormat("assets/fonts/Our-Arcade-Games.ttf", 20, FlxColor.GOLDEN, "center");
		head.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		head.scale.set(2, 2);
		playBtn = new Button(50, 200, 220, 30, "assets/images/button.png", "NEXT LEVEL");
		//helpBtn = new Button(100, 185, 120, 30, "assets/images/button.png", "HELP");
		
		add(new FlxSprite(0, 0, "assets/images/menubackground.png"));
		add(subHead);
		add(head);
		add(playBtn);
		//add(helpBtn);
		
		MouseEventManager.add(playBtn.clickRegion, null, play,null,null,false,true,false);
		//MouseEventManager.add(helpBtn.clickRegion, null, help,null,null,false,true,false);
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
	}
	
	public function play(sprite:FlxSprite = null)
	{
		FlxG.switchState(new PlayState());
	}
	
	public function help(sprite:FlxSprite = null)
	{
		FlxG.switchState(new HelpState());
	}
}