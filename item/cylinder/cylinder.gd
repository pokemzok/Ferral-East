extends Item

@onready var animation = $AnimatedSprite2D

func _ready():
	type = ItemType.BULLET_UPGRADE

func _process(delta):
	animation.play("glow")	