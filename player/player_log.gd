extends Node

var visited_locations = []
var log_capacity = 100
var previous_location: String
var current_location: String

func _ready():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_ARRIVED_TO_LEVEL, on_new_level)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_LEFT_SHOP, on_player_left_shop)
	
func on_new_level(level: LevelManager.Levels):
	var new_level = LevelManager.get_instance().get_level_name(level)
	visited_locations.append(new_level)
	previous_location = current_location
	current_location = new_level
	format_log()

func on_player_left_shop():
	var new_level = previous_location
	visited_locations.append(new_level)
	previous_location = current_location
	current_location = new_level
	format_log() 

func format_log():
	if (visited_locations.size() > log_capacity):
		visited_locations = visited_locations.slice(log_capacity/2, visited_locations.size())
