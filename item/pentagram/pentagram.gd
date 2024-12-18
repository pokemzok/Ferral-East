extends Item

@onready var animation = $AnimatedSprite2D

func _ready():
	type = ItemType.IMMEDIATE
	id = ItemID.PENTAGRAM

func _process(_delta):
	animation.play("glow")	

func is_evil() -> bool:
	return true
