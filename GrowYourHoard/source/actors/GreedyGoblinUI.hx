package actors;
import actors.GreedyGoblin;

/**
 * ...
 * @author John Doughty
 */
class GreedyGoblinUI extends actors.GreedyGoblin
{

	override public function update():Void
	{
	}

	override private function setup()
	{
		loadGraphic("assets/images/goblinbigbag.png", true, 20, 20);
		setGraphicSize(16, 16);
		updateHitbox();
	}
	
}