extends Item

@onready var animation = $AnimatedSprite2D
var item_to_initialize = preload("res://weapon/melee/skeleton_arm/left_skeleton_arm.tscn")
var interaction_behaviour = InteractionBehaviour.new()
var red = 4.0
var increasing = false
var interaction_name = "Skeleton_arm"

func _ready():
	type = ItemType.LEFT_HAND_ITEM
	id = ItemID.SKELETON_ARM
	animation.self_modulate = Color(red, 1.0, 1.0, 1.0)
	GlobalEventBus.connect(GlobalEventBus.FINISH_INTERACTION, conversation_ended)

func _process(delta):
	glow(delta)
	interaction_behaviour.process_interaction(interaction_name)
	interaction_behaviour.process_interaction_cooldown(delta)	
	
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

func _on_interraction_box_body_entered(body):
	return interaction_behaviour._on_interraction_box_body_entered(body)

func _on_interraction_box_body_exited(body):
	return interaction_behaviour._on_interraction_box_body_exited(body)

func conversation_ended():
	interaction_behaviour.max_interaction_cooldown()
