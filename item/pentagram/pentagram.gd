extends Item

@onready var animation = $AnimatedSprite2D

func _ready():
	type = ItemType.IMMEDIATE
	id = ItemID.PENTAGRAM

func _process(delta):
	animation.play("glow")	

func is_evil() -> bool:
	return true
