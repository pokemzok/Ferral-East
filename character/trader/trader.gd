class_name Trader
extends CharacterBody2D

var interaction_info_cooldown =NumericAttribute.new(0, 1)
var ready_for_interaction = false
var pausable = PausableNodeBehaviour.new(self)

func process_interaction(trader_name: String):
	if(ready_for_interaction):
		if Input.is_action_just_pressed("interact"):
			GlobalEventBus.start_conversation_with.emit(trader_name)
			

func _on_interraction_box_body_entered(body):
	if body.is_in_group("player"):
		ready_for_interaction = true
		if (interaction_info_cooldown.is_lte_zero()):
			GlobalEventBus.interaction_hint.emit()

func _on_interractionbox_body_exited(body):
	if body.is_in_group("player"):
		GlobalEventBus.interaction_hint_hide.emit()
		ready_for_interaction = false
	
