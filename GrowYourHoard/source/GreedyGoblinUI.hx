package;

/**
 * ...
 * @author John Doughty
 */
class GreedyGoblinUI extends GreedyGoblin
{

	override public function update():Void
	{
	}

	override private function setup()
	{
		loadGraphic("assets/images/goblinbigbag.png", true, 8, 8);
		setGraphicSize(16, 16);
		updateHitbox();
	}
	
}