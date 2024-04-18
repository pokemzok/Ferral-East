extends Item

@onready var animation = $AnimatedSprite2D

func _ready():
	type = ItemType.COIN

func _process(delta):
	animation.play("glow")	
