extends Node

var sound_manager = GameSoundManager.get_instance()

func play_sound_effect(sound_type: GameSoundManager.Sounds):
	var player = get_idle_audio_player()
	if  (sound_manager.sound_files.has(sound_type)):
		player.stream = sound_manager.sound_files[sound_type]
		player.play()
	else:
		print("Sound type not found: ", sound_type)	



func get_idle_audio_player():
	for child in get_children():
		var audio_player = child as AudioStreamPlayer
		if not audio_player.is_playing():
			return audio_player
	return get_children()[0]
