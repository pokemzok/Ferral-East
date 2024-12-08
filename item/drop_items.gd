extends Node
class_name DropItems

static var res_dictionary  = {
	Item.ItemID.COIN: "res://item/coin/coin.tscn",
	Item.ItemID.PENTAGRAM: "res://item/pentagram/pentagram.tscn",
	Item.ItemID.CYLINDER: "res://item/cylinder/cylinder.tscn",
	Item.ItemID.SKELETON_ARM: "res://item/weapons/skeleton_arm/skeleton_arm_item.tscn",
	Item.ItemID.PHASING_ORB: "res://item/weapons/phasing_orb/phasing_orb_item.tscn"
}

static var drop_chances = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: 0.015,
	Enemy.EnemyType.FAST_ZOMBIE: 0.020,
	Enemy.EnemyType.REANIMATING_ZOMBIE: 0.020,
	Enemy.EnemyType.KILT_WESTON: 1
}

static var common_items = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: Item.ItemID.COIN,
	Enemy.EnemyType.FAST_ZOMBIE: Item.ItemID.COIN,
	Enemy.EnemyType.REANIMATING_ZOMBIE: Item.ItemID.COIN,
	Enemy.EnemyType.KILT_WESTON: Item.ItemID.PENTAGRAM
}

static var rare_items = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: Item.ItemID.COIN,
	Enemy.EnemyType.FAST_ZOMBIE: Item.ItemID.PENTAGRAM,
	Enemy.EnemyType.REANIMATING_ZOMBIE: Item.ItemID.CYLINDER,
	Enemy.EnemyType.KILT_WESTON: Item.ItemID.SKELETON_ARM
}

static var legendary_items = {
	Enemy.EnemyType.DEFAULT_ZOMBIE: Item.ItemID.COIN,
	Enemy.EnemyType.REANIMATING_ZOMBIE: Item.ItemID.PHASING_ORB,
	Enemy.EnemyType.FAST_ZOMBIE: Item.ItemID.SKELETON_ARM,
	Enemy.EnemyType.KILT_WESTON: Item.ItemID.PHASING_ORB
}

static var instance = null

static func get_instance() -> DropItems:
	if instance == null:
		instance = DropItems.new()
		instance.name = "DropItems"
		instance.add_to_group("singleton")
	return instance	
