extends ShopItem

@onready var animations = $AnimatedSprite2D

func _ready():
	type = ItemType.CONSUMABLE
	item_name = "WATER"
	id = ItemID.WATER
	inventory_texture_path = "res://item/shop/water/water_inventory.png"
	price = 3
	input_pickable = true

func _on_mouse_entered():
	animations.play("highlight")

func _on_mouse_exited():
	animations.play("default")

