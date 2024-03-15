extends Node

var player = preload("res://characters/surbi/surbi.tscn")  #Hardcoded for now

func _ready():
	var parent  = get_parent()  #asumes that player has a Node2D parent
	var player_instance = player.instantiate()
	player_instance.position = parent.position
	add_child(player_instance)
	connect_player_to_hud(player_instance)
	player_instance.after_external_init()

func connect_player_to_hud(player):
	player.connect("hp_changed", $Hud.on_hp_changed)
