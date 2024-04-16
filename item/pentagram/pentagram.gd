extends Item

@onready var animation = $AnimatedSprite2D

func _ready():
	type = ItemType.HEAL

func _process(delta):
	animation.play("glow")	
