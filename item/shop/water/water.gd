extends Item

@onready var animations = $AnimatedSprite2D
# FIXME parent disrupts highlight. How to fix it?
# TODO: maybe tutorials on how to do that
func _ready():
	type = ItemType.HEAL
	price = 3
	input_pickable = true

func _on_mouse_entered():
	animations.play("highlight")

func _on_mouse_exited():
	animations.play("default")
