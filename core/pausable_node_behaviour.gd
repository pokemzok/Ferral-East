class_name PausableNodeBehaviour

var parent: Node

func _init(parent_node: Node):
	parent = parent_node

func set_pause(pause):
	parent.set_process(!pause)
	parent.set_physics_process(!pause)
