extends StaticBody2D
class_name Item

enum ItemType {
	NONE,
	COIN,
	HEAL,
	BULLET_UPGRADE,
	EFFECT
}

enum ItemName {
	COIN,
	PENTAGRAM,
	CYLINDER,
	WATER,
	CATNIP
}

var type = ItemType.NONE
var price = 0

func get_item_type() -> ItemType:
	return type

func is_coin() -> bool:
	return type == ItemType.COIN
