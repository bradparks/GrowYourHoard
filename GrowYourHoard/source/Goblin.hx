package;

import flixel.FlxSprite;

/**
 * ...
 * @author John Doughty
 */
class Goblin extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic)
	{
		super(X, Y, SimpleGraphic);

		solid = false;
		loadGraphic("assets/images/goblin1.png", true, 8, 8);
		animation.add("main", [0, 1], 4, true);
		setGraphicSize(20, 20);
		flipX = true;
		animation.play("main");
	}

	override public function update():Void
	{
		super.update();
		this.x -= 1;
		if (this.x < 0 - width)
		{
			PlayState.score += 1;
			kill();
		}
	}
}