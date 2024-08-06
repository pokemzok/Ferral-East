extends ShopItem

@onready var animations = $AnimatedSprite2D

# FIXME
# Think if the drawing is good enough. Maybe more relastic plus no weapon parts visible?
# Those could either increase damage or add more bullets to the weapon.

func _ready():
	type = ItemType.CONSUMABLE
	item_name = "REVOLVER_PARTS"
	id = ItemName.REVOLVER_PARTS
	inventory_texture_path = "res://item/shop/revolver_parts/revolver_parts_inventory.png"
	price = 10
	input_pickable = true

func _on_mouse_entered():
	animations.play("highlight")

func _on_mouse_exited():
	animations.play("default")
