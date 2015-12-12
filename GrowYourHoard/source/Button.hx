package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author John Doughty
 */
class Button extends FlxGroup
{
	public var background:FlxSprite;
	public var text:FlxText;
	public var clickRegion:FlxSprite;
	public function new(x, y, width, height, backgroundSpriteFile, textString) 
	{
		super();
		background = new FlxSprite(x, y, backgroundSpriteFile);
		background.setGraphicSize(width, height);
		background.updateHitbox();
		text = new FlxText(x, y +height/8, width);
		text.text = textString;
		text.setFormat("assets/fonts/Our-Arcade-Games.ttf", height - height/4, FlxColor.GOLDEN, "center");
		text.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BROWN, 1);
		
		clickRegion = new FlxSprite(x, y);
		clickRegion.makeGraphic(width, height);
		clickRegion.alpha = 0;
		add(background);
		add(text);
		add(clickRegion);
	}
	
}