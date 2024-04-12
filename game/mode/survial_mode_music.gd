class_name SurvivalModeMusic
extends Node

var music_for_waves: ArrayCollection
var music_for_rest: ArrayCollection

func _init(music_for_waves: ArrayCollection, music_for_rest: ArrayCollection):
	self.music_for_waves = music_for_waves
	self.music_for_rest = music_for_rest

func get_music_for_wave(wave_index: int):
	if(music_for_waves.size() == 0):
		return
	
	if(wave_index < music_for_waves.size()):
		return music_for_waves.get_element_by_index(wave_index)
	else:
		var max_range = min(3, max(0, music_for_waves.size() - 2))
		var random_index = randi_range(0, max_range)
		return music_for_waves.get_element_by_index(random_index)

func get_music_for_rest():
	if(music_for_rest.size() == 0):
		return
	return music_for_rest.random_element()
