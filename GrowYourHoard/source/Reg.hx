package;

class Reg
{
	public static var score:Int = 0;
	public static var level:Int = 0;

	public static var counters:Map<String, Int> = [
		"goblins_launched" => 0,
		"arrows_launched"  => 0,
		"arrows_blocked"   => 0
	];
}