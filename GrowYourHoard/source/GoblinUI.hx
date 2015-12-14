package;

/**
 * ...
 * @author John Doughty
 */
class GoblinUI extends Goblin
{
	override function setup() 
	{
		loadGraphic(AssetPaths.goblin1__png, true, 8, 8);
		setGraphicSize(16, 16);
		updateHitbox();
	}
	
	override public function update():Void 
	{
		
	}
}