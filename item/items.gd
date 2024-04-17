extends Node
class_name Items

enum ItemName {
	PENTAGRAM
}

static var res_dictionary  = {
	ItemName.PENTAGRAM: "res://item/pentagram/pentagram.tscn"
}

static var drop_chances = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: 0.05
}
# FIXME different items for zombie, now all tiers are the same
static var common_items = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: ItemName.PENTAGRAM
}

static var rare_items = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: ItemName.PENTAGRAM
}

static var legendary_items = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: ItemName.PENTAGRAM
}

static var instance = null

static func get_instance() -> Items:
	if instance == null:
		instance = Items.new()
		instance.name = "Items"
		instance.add_to_group("singleton")
	return instance	
