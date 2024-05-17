extends Node
class_name DropItems

static var res_dictionary  = {
	Item.ItemName.COIN: "res://item/coin/coin.tscn",
	Item.ItemName.PENTAGRAM: "res://item/pentagram/pentagram.tscn",
	Item.ItemName.CYLINDER: "res://item/cylinder/cylinder.tscn"
}

static var drop_chances = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: 0.015
}

static var common_items = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: Item.ItemName.COIN
}

static var rare_items = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: Item.ItemName.PENTAGRAM
}

static var legendary_items = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: Item.ItemName.CYLINDER
}

static var instance = null

static func get_instance() -> DropItems:
	if instance == null:
		instance = DropItems.new()
		instance.name = "DropItems"
		instance.add_to_group("singleton")
	return instance	
