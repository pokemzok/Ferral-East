extends Item

@onready var animation = $AnimatedSprite2D

func _ready():
	type = ItemType.COIN
	price = 1
	
func _process(delta):
	animation.play("glow")	
