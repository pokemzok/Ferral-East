extends Node2D

func _ready():
	GlobalEventBus.player_entered_shop.emit()
	
