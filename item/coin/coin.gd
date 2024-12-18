extends Item

@onready var animation = $AnimatedSprite2D

func _ready():
	type = ItemType.IMMEDIATE
	id = ItemID.COIN
	price = 1
	
func _process(_delta):
	animation.play("glow")	
