extends Item

@onready var animation = $AnimatedSprite2D

func _ready():
	type = ItemType.CONSUMABLE
	id = ItemID.CYLINDER
	inventory_texture_path = "res://item/cylinder/cylinder_inventory.png"
	price = 10

func _process(delta):
	animation.play("glow")	
