extends InteractableItem

@onready var animation = $AnimatedSprite2D
var item_to_initialize = preload("res://weapon/melee/skeleton_arm/left_skeleton_arm.tscn")
var red = 4.0
var increasing = false

func _ready():
	type = ItemType.LEFT_HAND_ITEM
	id = ItemID.SKELETON_ARM
	interaction_name = "Skeleton_arm"
	animation.self_modulate = Color(red, 1.0, 1.0, 1.0)
	GlobalEventBus.connect(GlobalEventBus.FINISH_INTERACTION, interaction_ended)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_PICKED_UP_LEFT_ARM_ITEM, on_pickup)

func _process(delta):
	glow(delta)
	process_interactions(delta)
	
func glow(delta):
	if red >= 4.0:
		increasing = false
	elif red <= 1.0:
		increasing = true
	red += delta if increasing else -delta
	animation.self_modulate = Color(red, 1.0, 1.0, 1.0)

func is_evil() -> bool:
	return true

func instantiate():
	return item_to_initialize.instantiate()
