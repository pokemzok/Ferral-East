extends Node

var player = preload("res://characters/surbi/surbi.tscn")  #Hardcoded for now
# FIXME interesting concept, but not sure if I can use it, since it messes up few things
func _ready():
	var playerInstance = player.instantiate()
	playerInstance.position = self.position
	add_child(playerInstance)
