extends Node2D

var trader = preload("res://character/trader/sharik/sharik.tscn")  #Hardcoded for now

func _ready():
	GlobalEventBus.connect(GlobalEventBus.WAVE_COMPLETED, spawn_trader)

# Fixme should be 30% chance, which could increase up to  60 if the player behaves nicely
# I can also increase chances with each wave
func spawn_trader(wave_index):
	var parent  = get_parent()  #asumes that player has a Node2D parent
	var trader_instance = trader.instantiate()
	trader_instance.position = parent.position
	call_deferred("add_child", trader_instance)
