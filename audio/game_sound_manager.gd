extends Node

class_name GameSoundManager

enum Sounds {
	REVOLVER_RELOAD,
	REVOLVER_SHOOT
}

var sound_files = {
	Sounds.REVOLVER_RELOAD: preload("res://audio/weapons/revolver-reload-shorter.wav"),
	Sounds.REVOLVER_SHOOT: preload("res://audio/weapons/revolver-shot.mp3")
}

static var instance = null

static func get_instance():
	if instance == null:
		instance = GameSoundManager.new()
		instance.name = "GameAudioManager"
		instance.add_to_group("singleton")
	return instance	
