extends StaticBody2D
class_name Item

enum ItemType {
	NONE,
	HEAL,
	SPEED_INC,
	BULLET_UPGRADE,
}

var type = ItemType.NONE

func get_item_type() -> ItemType:
	return type
