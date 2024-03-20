class_name GameSoundManager

enum Sounds {
	REVOLVER_RELOAD,
	REVOLVER_SHOOT
}

var sound_files = {
	Sounds.REVOLVER_RELOAD: preload("res://audio/weapons/revolver-reload-shorter.wav"),
	Sounds.REVOLVER_SHOOT: preload("res://audio/weapons/revolver-shot.mp3")
}

func play_sound_effect(sound_type: Sounds, player: AudioStreamPlayer):
	if  (sound_files.has(sound_type)):
		player.stream = sound_files[sound_type]
		player.play()
	else:
		print("Sound type not found: ", sound_type)	

