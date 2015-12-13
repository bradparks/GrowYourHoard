package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.plugin.MouseEventManager;
/**
 * ...
 * @author John Doughty
 */
class Button extends FlxGroup
{
	public var background:FlxSprite;
	public var text:FlxText;
	public var clickRegion:FlxSprite;

	public function new(x:Float, y:Float, width:Int, height:Int, backgroundSpriteFile:String, textString:String, click:Dynamic,?fontSize:Int)
	{
		super();
		background = new FlxSprite(x, y, backgroundSpriteFile);
		background.setGraphicSize(width, height);
		background.updateHitbox();
		text = new FlxText(x, y + height/8, width);
		text.text = textString;
		text.setFormat("assets/fonts/Our-Arcade-Games.ttf", fontSize == null?height - height/4:fontSize, FlxColor.GOLDEN, "center");
		text.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);

		clickRegion = new FlxSprite(x, y);
		clickRegion.makeGraphic(width, height);
		clickRegion.alpha = 0;
		add(background);
		add(text);
		add(clickRegion);
		MouseEventManager.add(clickRegion, null, click, over, out,false,true,false);
	}
	
	public function over(sprite:FlxSprite)
	{
		clickRegion.alpha = 0.2;
	}
	
	public function out(sprite:FlxSprite)
	{
		clickRegion.alpha = 0;
	}
}