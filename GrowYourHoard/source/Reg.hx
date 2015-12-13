package;

class Reg
{
	public static var score:Int = 0;
	public static var level:Int = 0;

	public static var counters = [
		"goblins_launched"        => 0,
		"greedy_goblins_launched" => 0,
		"ogres_launched"          => 0,
		"arrows_launched"         => 0,
		"axes_launched"         => 0,
		"axes_blocked"          => 0,
		"arrows_blocked"          => 0
	];

	public static var upgrades = [
		"goblin" => [
			"cost"   => 0,
			"number" => 999999999
		],
		"greedy_goblin" => [
			"cost"   => 1,
			"number" => 0
		],
		"ogre" => [
			"cost"   => 1,
			"number" => 0
		],
		"large_shield" => [
			"cost"   => 5,
			"number" => 0
		]
	];
}