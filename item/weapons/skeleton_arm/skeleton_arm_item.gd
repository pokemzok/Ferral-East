extends Item

@onready var animation = $AnimatedSprite2D
var red = 4.0
var increasing = false

func _ready():
	type = ItemType.LEFT_HAND_ITEM
	id = ItemID.SKELETON_ARM
	animation.self_modulate = Color(red, 1.0, 1.0, 1.0)

func _process(delta):
	glow(delta)
	
func glow(delta):
	if red >= 4.0:
		increasing = false
	elif red <= 1.0:
		increasing = true
	red += delta if increasing else -delta

	animation.self_modulate = Color(red, 1.0, 1.0, 1.0)

func is_evil() -> bool:
	return true
