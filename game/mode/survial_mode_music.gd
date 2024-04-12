class_name SurvivalModeMusic
extends Node

var music_for_waves: ArrayCollection
var victory_music: ArrayCollection

func _init(music_for_waves: ArrayCollection, victory_music: ArrayCollection):
	self.music_for_waves = music_for_waves
	self.victory_music = victory_music

func get_music_for_wave(wave_index: int):
	if(music_for_waves.size() == 0):
		return
	
	if(wave_index < music_for_waves.size()):
		return music_for_waves.get_element_by_index(wave_index)
	else:
		var max_range = min(3, max(0, music_for_waves.size() - 2))
		var random_index = randi_range(0, max_range)
		return music_for_waves.get_element_by_index(random_index)

func get_victory_music():
	if(victory_music.size() == 0):
		return
	return victory_music.random_element()
