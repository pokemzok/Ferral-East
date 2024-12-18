class_name GameStatistics
extends Node

var completed_waves = 0

func _ready():
	connect_events()
	
func connect_events():
	GlobalEventBus.connect(GlobalEventBus.WAVE_COMPLETED, on_completed_wave)
	
func on_completed_wave(_wave_index):
	completed_waves+=1		
