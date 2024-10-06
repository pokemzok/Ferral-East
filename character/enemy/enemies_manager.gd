extends Node
class_name EnemiesManager

static var instance = null

static func get_instance() -> EnemiesManager:
	if instance == null:
		instance = EnemiesManager.new()
		instance.name = "EnemiesManager"
		instance.add_to_group("singleton")
	return instance	

var enemy_res = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: "res://character/enemy/zombie/default/default_zombie.tscn",
	Enemy.EnemyType.FAST_ZOMBIE: "res://character/enemy/zombie/fast/fast_zombie.tscn",
	Enemy.EnemyType.REANIMATING_ZOMBIE: "res://character/enemy/zombie/reanimating/reanimating_zombie.tscn",
}

var bosses_res = {
	Enemy.EnemyType.KILT_WESTON: "res://character/enemy/boss/kilt_weston/kilt_weston.tscn"
}

var zombie_keys = [Enemy.EnemyType.DEFAULT_ZOMBIE, Enemy.EnemyType.FAST_ZOMBIE, Enemy.EnemyType.REANIMATING_ZOMBIE]
var bosses_keys = [Enemy.EnemyType.KILT_WESTON]
