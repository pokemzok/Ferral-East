extends Node
class_name DropItems

enum ItemName {
	COIN,
	PENTAGRAM,
	CYLINDER
}

static var res_dictionary  = {
	ItemName.COIN: "res://item/coin/coin.tscn",
	ItemName.PENTAGRAM: "res://item/pentagram/pentagram.tscn",
	ItemName.CYLINDER: "res://item/cylinder/cylinder.tscn"
}

static var drop_chances = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: 0.015
}

static var common_items = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: ItemName.COIN
}

static var rare_items = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: ItemName.PENTAGRAM
}

static var legendary_items = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: ItemName.CYLINDER
}

static var instance = null

static func get_instance() -> DropItems:
	if instance == null:
		instance = DropItems.new()
		instance.name = "DropItems"
		instance.add_to_group("singleton")
	return instance	
