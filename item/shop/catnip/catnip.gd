extends ShopItem

@onready var animations = $AnimatedSprite2D

func _ready():
	type = ItemType.CONSUMABLE
	id = ItemName.CATNIP
	item_name = "CATNIP"
	price = 5
	texture_path = "res://assets/hud/catnip.png"
	input_pickable = true
	
func _on_mouse_entered():
	animations.play("highlight")

func _on_mouse_exited():
	animations.play("default")
