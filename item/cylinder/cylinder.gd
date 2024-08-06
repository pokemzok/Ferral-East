extends Item

@onready var animation = $AnimatedSprite2D

func _ready():
	type = ItemType.CONSUMABLE
	id = ItemName.CYLINDER

func _process(delta):
	animation.play("glow")	
