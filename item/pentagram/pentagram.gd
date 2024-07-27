extends Item

@onready var animation = $AnimatedSprite2D

func _ready():
	type = ItemType.HEAL
	id = ItemName.PENTAGRAM

func _process(delta):
	animation.play("glow")	
