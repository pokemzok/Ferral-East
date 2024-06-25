extends Item

@onready var animations = $AnimatedSprite2D

# FIXME
# I can draw those differently too. Those could either increase damage or add more bullets to the weapon.

func _ready():
	type = ItemType.BULLET_UPGRADE
	price = 10
	input_pickable = true

func _on_mouse_entered():
	animations.play("highlight")

func _on_mouse_exited():
	animations.play("default")
