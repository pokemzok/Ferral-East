extends ShopItem

@onready var animations = $AnimatedSprite2D

func _ready():
	type = ItemType.CONSUMABLE
	item_name = "REVOLVER_PARTS"
	id = ItemID.REVOLVER_PARTS
	inventory_texture_path = "res://item/shop/revolver_parts/revolver_parts_inventory.png"
	price = 7
	input_pickable = true

func _on_mouse_entered():
	animations.play("highlight")

func _on_mouse_exited():
	animations.play("default")
