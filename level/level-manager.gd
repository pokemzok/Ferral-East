
extends Node

class_name LevelManager

static var instance = null

enum Levels {
	TEST,
	HOMETOWN,
	ABANDONED_FARM,
	SHARIK_SHOP
}

var level_names = {
	Levels.TEST: "test",
	Levels.ABANDONED_FARM: "abandoned_farm",
	Levels.SHARIK_SHOP: "sharik_shop"
}

var level_paths = {
	Levels.TEST: "res://level/test/test-level.tscn",	
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
	

func get_level_name(level: Levels):
	if  (level_names.has(level)):
		return level_names[level]
	else:
		print("Level name not found: ", level)	
