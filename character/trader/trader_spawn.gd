extends Node2D

var trader = preload("res://character/trader/sharik/sharik.tscn")  #Hardcoded for now

func _ready():
	GlobalEventBus.connect(GlobalEventBus.WAVE_COMPLETED, spawn_trader)

# FIXME should be 100 % after the second wave
# FIXME if the player shoots sharik until he dissappears, he should not appear for next two waves, if the player would do so 2 more times the void starts appearing instead
# FIXME trader appearence would also be affected by player karma
func spawn_trader(_wave_index):
	var parent  = get_parent()  #asumes that player has a Node2D parent
	var trader_instance = trader.instantiate()
	trader_instance.position = parent.position
	call_deferred("add_child", trader_instance)
