extends StaticBody2D
class_name Item

enum ItemType {
	NONE,
	COIN,
	HEAL,
	BULLET_UPGRADE,
}

var type = ItemType.NONE

func get_item_type() -> ItemType:
	return type

func is_coin() -> bool:
	return type == ItemType.COIN
