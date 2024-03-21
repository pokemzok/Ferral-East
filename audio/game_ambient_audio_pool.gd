extends Node

var sound_manager = GameSoundManager.get_instance()

func play_sound_effect(sound_type: GameSoundManager.Sounds):
	var player = get_idle_audio_player()
	sound_manager.play_sound(sound_type,  player)

func get_idle_audio_player():
	for child in get_children():
		var audio_player = child as AudioStreamPlayer
		if not audio_player.is_playing():
			return audio_player
	return get_children()[0]
