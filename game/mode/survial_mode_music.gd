class_name SurvivalModeMusic
extends Node

var waves_music_player: AudioStreamPlayer
var victory_music_player: AudioStreamPlayer
var music_for_waves: ArrayCollection
var victory_music: ArrayCollection

func _init(
	music_for_waves: ArrayCollection, 
	waves_music_player: AudioStreamPlayer,
	victory_music: ArrayCollection,
	victory_music_player: AudioStreamPlayer):
	self.music_for_waves = music_for_waves
	self.victory_music = victory_music
	self.waves_music_player = waves_music_player
	victory_music_player.autoplay = false
	self.victory_music_player = victory_music_player

func play_on_wave(wave_index):
	if (!waves_music_player.is_playing()):
		waves_music_player.stream = get_music_for_wave(wave_index)	
		waves_music_player.play()
		waves_music_player.autoplay = true

func play_on_wave_complete():
	if(waves_music_player.is_playing()):
		waves_music_player.stop()
		waves_music_player.autoplay = false
	victory_music_player.stream = get_victory_music()
	victory_music_player.play()

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
