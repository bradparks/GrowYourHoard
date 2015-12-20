package actors;

/**
 * ...
 * @author John Doughty
 */
class GoblinShow extends actors.Goblin
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