package actors;

/**
 * ...
 * @author John Doughty
 */
class OgreShow extends actors.Ogre
{
	override function getScore()
	{
		return 0;
	}

	override function getTargetY()
	{
		return 84;
	}
}