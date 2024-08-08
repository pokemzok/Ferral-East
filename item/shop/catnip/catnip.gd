extends ShopItem

@onready var animations = $AnimatedSprite2D

func _ready():
	type = ItemType.CONSUMABLE
	id = ItemID.CATNIP
	item_name = "CATNIP"
	price = 5
	inventory_texture_path = "res://item/shop/catnip/catnip_inventory.png"
	input_pickable = true
	
func _on_mouse_entered():
	animations.play("highlight")

func _on_mouse_exited():
	animations.play("default")
