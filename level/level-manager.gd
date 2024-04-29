
extends Node

class_name LevelManager

static var instance = null

enum Levels {
	TEST,
	HOMETOWN,
	SHARIK_SHOP
}

var level_paths = {
	Levels.TEST: "res://level/test/test-level.tscn",	
	Levels.HOMETOWN: "res://level/hometown/hometown.tscn",	
	Levels.SHARIK_SHOP: "res://level/shop/sharik/sharik_shop.tscn",	
}

static func get_instance() -> LevelManager:
	if instance == null:
		instance = LevelManager.new()
		instance.name = "LevelManager"
		instance.add_to_group("singleton")
	return instance	

func get_level(level: Levels):
	if  (level_paths.has(level)):
		return level_paths[level]
	else:
		print("Level not found: ", level)	
	
