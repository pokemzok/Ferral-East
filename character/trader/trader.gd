class_name Trader
extends CharacterBody2D

var pausable = PausableNodeBehaviour.new(self)
var interaction_behaviour = InteractionBehaviour.new()

func _on_interraction_box_body_entered(body):
	interaction_behaviour._on_interraction_box_body_entered(body)

func _on_interractionbox_body_exited(body):
	interaction_behaviour._on_interraction_box_body_exited(body)
	
