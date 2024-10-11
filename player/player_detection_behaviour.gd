class_name PlayerDetectionBehaviour

var parent: Node

func _init(parent_node: Node):
	parent = parent_node

func get_player():
	var players = parent.get_tree().get_nodes_in_group("player")
	if !players.is_empty(): # FIXME multiplayer support
		return players[0]
	else:
		push_error("No player in a scene tree")	
