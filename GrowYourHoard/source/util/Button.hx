package util;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.plugin.MouseEventManager;
import flixel.FlxG;
import flixel.input.touch.FlxTouch;
/**
 * ...
 * @author John Doughty
 */
class Button extends FlxGroup
{
	public var background:FlxSprite;
	public var text:FlxText;
	public var clickRegion:FlxSprite;
	public var clickFunc:Dynamic;

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
		#if !mobile
		MouseEventManager.add(clickRegion, null, click, over, out, false, true, false);
		#else
		clickFunc = click;
		#end
	}

	public function over(sprite:FlxSprite)
	{
		clickRegion.alpha = 0.2;
	}

	public function out(sprite:FlxSprite)
	{
		clickRegion.alpha = 0;
	}
	
	override public function update():Void 
	{
		super.update();
		var touch:FlxTouch;
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed && 
			touch.x >= clickRegion.x &&
			touch.x <= clickRegion.x + clickRegion.width &&
			touch.y >= clickRegion.y &&
			touch.y <= clickRegion.y + clickRegion.height &&
			clickFunc != null)
			{
				clickFunc();
			}

			if (touch.pressed)
			{
			}

			if (touch.justReleased)
			{
			}
		}
	}
}