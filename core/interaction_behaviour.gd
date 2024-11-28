class_name InteractionBehaviour
extends Node

var interaction_info_cooldown = NumericAttribute.new(0, 1)
var interaction_cooldown = NumericAttribute.new(0, 0.25)
var ready_for_interaction = false

func process_interaction(trader_name: String):
	if(ready_for_interaction && interaction_cooldown.is_lte_zero()):
		if Input.is_action_just_pressed("interact"):
			GlobalEventBus.start_interaction_with.emit(trader_name)
			

func process_interaction_cooldown(delta):
	if(interaction_info_cooldown.is_gt_zero()):
		interaction_info_cooldown.decrement_by(delta)
	if(interaction_cooldown.is_gt_zero()):
		interaction_cooldown.decrement_by(delta)	

func max_interaction_cooldown():
	interaction_cooldown.assign_max_value()

func _on_interraction_box_body_entered(body):
	if body.is_in_group("player"):
		ready_for_interaction = true
		if (interaction_info_cooldown.is_lte_zero()):
			GlobalEventBus.interaction_hint.emit()

func _on_interraction_box_body_exited(body):
	if body.is_in_group("player"):
		GlobalEventBus.interaction_hint_hide.emit()
		ready_for_interaction = false
	
