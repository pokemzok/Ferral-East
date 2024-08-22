extends Node
class_name DropItems

static var res_dictionary  = {
	Item.ItemID.COIN: "res://item/coin/coin.tscn",
	Item.ItemID.PENTAGRAM: "res://item/pentagram/pentagram.tscn",
	Item.ItemID.CYLINDER: "res://item/cylinder/cylinder.tscn"
}

static var drop_chances = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: 0.015,
	Enemy.EnemyType.FAST_ZOMBIE: 0.020,
	Enemy.EnemyType.REANIMATING_ZOMBIE: 0.020
}

static var common_items = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: Item.ItemID.COIN,
	Enemy.EnemyType.FAST_ZOMBIE: Item.ItemID.COIN,
	Enemy.EnemyType.REANIMATING_ZOMBIE: Item.ItemID.COIN
}

static var rare_items = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: Item.ItemID.COIN,
	Enemy.EnemyType.FAST_ZOMBIE: Item.ItemID.PENTAGRAM,
	Enemy.EnemyType.REANIMATING_ZOMBIE: Item.ItemID.COIN
}

static var legendary_items = {
	Enemy.EnemyType.REANIMATING_ZOMBIE: Item.ItemID.CYLINDER,
	Enemy.EnemyType.FAST_ZOMBIE: Item.ItemID.PENTAGRAM
}

static var instance = null

static func get_instance() -> DropItems:
	if instance == null:
		instance = DropItems.new()
		instance.name = "DropItems"
		instance.add_to_group("singleton")
	return instance	
