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
class HelpState extends FlxState
{
	var text:FlxText;
	var head:FlxText;
	var playBtn:Button;
	var menuBtn:Button;
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();
		head = new FlxText(0,20, 320);
		head.text = "Help";
		head.setFormat("assets/fonts/Our-Arcade-Games.ttf", 20, FlxColor.GOLDEN, "center");
		head.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		head.scale.set(2, 2);
		text = new FlxText(0, 60, 300);
		text.text = "Press D or A to go Left and Right and shield your loyal minions from arrow fire";
		text.setFormat("assets/fonts/Our-Arcade-Games.ttf", 13, FlxColor.GOLDEN, "center");
		
		text.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		playBtn = new Button(100, 150, 120, 30, "assets/images/button.png", "PLAY");
		menuBtn = new Button(100, 185, 120, 30, "assets/images/button.png", "MENU");
		
		add(new FlxSprite(0, 0, "assets/images/menubackground.png"));
		add(text);
		add(head);
		add(playBtn);
		add(menuBtn);
		
		MouseEventManager.add(playBtn.clickRegion, null, play,null,null,false,true,false);
		MouseEventManager.add(menuBtn.clickRegion, null, menu,null,null,false,true,false);
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
	
	public function menu(sprite:FlxSprite = null)
	{
		FlxG.switchState(new MenuState());
	}
}