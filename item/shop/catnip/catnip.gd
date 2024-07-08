extends ShopItem

@onready var animations = $AnimatedSprite2D

func _ready():
	type = ItemType.EFFECT
	item_name = "CATNIP"
	price = 5
	input_pickable = true
	
func _on_mouse_entered():
	animations.play("highlight")

func _on_mouse_exited():
	animations.play("default")
