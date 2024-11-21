extends StaticBody2D
class_name Item

enum ItemType {
	NONE,
	IMMEDIATE,
	CONSUMABLE
}

enum ItemID {
	NO_NAME,
	COIN,
	PENTAGRAM,
	CYLINDER,
	REVOLVER_PARTS,
	WATER,
	CATNIP
}

@export var type = ItemType.NONE
@export var price = 0
@export var id = ItemID.NO_NAME
@export var quantity = 1
@export var inventory_texture_path = ""

func get_item_type() -> ItemType:
	return type

func is_coin() -> bool:
	return id == ItemID.COIN

func is_consumable() -> bool:
	return type == ItemType.CONSUMABLE

func is_evil() -> bool:
	return false	

func increment_quantity():
	quantity += 1
	
func use():
	if (type == ItemType.CONSUMABLE):
		if (quantity > 0):
			quantity-=1
			GlobalEventBus.player_consumed_item.emit(self)
