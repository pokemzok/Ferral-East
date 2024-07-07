class_name PlayerFactory

var player = preload("res://character/playable/surbi/surbi.tscn")

func create():
	return player.instantiate()

