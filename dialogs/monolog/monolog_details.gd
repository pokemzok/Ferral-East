class_name MonologDetails

var text: String
var attach_to_node: CharacterBody2D

func _init(text: String, attach_to_node: CharacterBody2D):
	self.text = text
	self.attach_to_node = attach_to_node
