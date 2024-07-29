extends StaticBody2D
class_name Item

enum ItemType {
	NONE,
	COIN,
	HEAL,
	BULLET_UPGRADE,
	CONSUMABLE
}

enum ItemName {
	NO_NAME,
	COIN,
	PENTAGRAM,
	CYLINDER,
	WATER,
	CATNIP
}

@export var type = ItemType.NONE
@export var price = 0
@export var id = ItemName.NO_NAME
@export var quantity = 1

func get_item_type() -> ItemType:
	return type

func is_coin() -> bool:
	return type == ItemType.COIN

func is_consumable() -> bool:
	return type == ItemType.CONSUMABLE

func increment_quantity():
	quantity += 1
	
func use():
	if (type == ItemType.CONSUMABLE):
		if (quantity > 0):
			quantity-=1
			GlobalEventBus.player_consumed_item.emit(self)
