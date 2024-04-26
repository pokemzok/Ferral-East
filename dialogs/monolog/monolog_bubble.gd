class_name MonologBubble
extends Node2D

@onready var label = $Polygon2D/Label
@onready var polygon = $Polygon2D

func _ready():
	# TODO, some event processing
	pass
	
func show_bubble(monolog_details: MonologDetails):
	label.text = monolog_details.text
	self.global_position = monolog_details.attach_to_node.global_position
	self.show()
		
