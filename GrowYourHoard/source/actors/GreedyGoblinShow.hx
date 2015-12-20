package actors;

/**
 * ...
 * @author John Doughty
 */
class GreedyGoblinShow extends actors.GreedyGoblin
{
	override function getScore()
	{
		return 0;
	}

	override function getTargetY()
	{
		return 135;
	}
}