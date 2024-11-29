class_name InteractableItem
extends Item

var interaction_name = "NONE"
var character_interacting
var interaction_behaviour = InteractionBehaviour.new()

func process_interactions(delta):
	interaction_behaviour.process_interaction(interaction_name)
	interaction_behaviour.process_interaction_cooldown(delta)	

func on_pickup(arg):
	if (interaction_name == arg && character_interacting != null):
		character_interacting.on_picked_item(self)

func _on_interraction_box_body_entered(body):
	if body.is_in_group("player"):
		character_interacting = body
	interaction_behaviour._on_interraction_box_body_entered(body)

func _on_interraction_box_body_exited(body):
	character_interacting = null
	interaction_behaviour._on_interraction_box_body_exited(body)

func interaction_ended():
	character_interacting = null
	interaction_behaviour.max_interaction_cooldown()
