extends Item

@onready var animation = $AnimatedSprite2D

func _ready():
	type = ItemType.BULLET_UPGRADE
	id = ItemName.CYLINDER

func _process(delta):
	animation.play("glow")	
