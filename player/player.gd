extends Node

var player = preload("res://character/playable/surbi/surbi.tscn")  #Hardcoded for now

func _ready():
	var parent  = get_parent()  #asumes that player has a Node2D parent
	var player_instance = player.instantiate()
	player_instance.position = parent.position
	add_child(player_instance)
	player_instance.after_external_init()

