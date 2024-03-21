extends Node

class_name GameSoundManager

enum Sounds {
	REVOLVER_RELOAD,
	REVOLVER_SHOOT,
	ZOMBIE_VOICE_1,
	ZOMBIE_VOICE_2,
	ZOMBIE_VOICE_3,
	ZOMBIE_VOICE_4,
	ZOMBIE_DEATH_1,
	ZOMBIE_DEATH_2,
	ZOMBIE_DEATH_3,
	ZOMBIE_DEATH_4,
}

var sound_files = {
	Sounds.REVOLVER_RELOAD: preload("res://audio/weapons/revolver-reload-shorter.wav"),
	Sounds.REVOLVER_SHOOT: preload("res://audio/weapons/revolver-shot.mp3"),
	Sounds.ZOMBIE_VOICE_1: preload("res://audio/enemies/zombie/zombie-voice-1.mp3"),
	Sounds.ZOMBIE_VOICE_2: preload("res://audio/enemies/zombie/zombie-voice-2.mp3"),
	Sounds.ZOMBIE_VOICE_3: preload("res://audio/enemies/zombie/zombie-voice-3.mp3"),
	Sounds.ZOMBIE_VOICE_4: preload("res://audio/enemies/zombie/zombie-voice-4.mp3"),
	Sounds.ZOMBIE_DEATH_1: preload("res://audio/enemies/zombie/zombie-death-1.mp3"),
	Sounds.ZOMBIE_DEATH_2: preload("res://audio/enemies/zombie/zombie-death-2.mp3"),
	Sounds.ZOMBIE_DEATH_3: preload("res://audio/enemies/zombie/zombie-death-3.mp3"),
	Sounds.ZOMBIE_DEATH_4: preload("res://audio/enemies/zombie/zombie-death-4.mp3")
}

static var instance = null

static func get_instance():
	if instance == null:
		instance = GameSoundManager.new()
		instance.name = "GameAudioManager"
		instance.add_to_group("singleton")
	return instance	

func play_sound(sound_type: Sounds, sound_player: Node):
	if  (sound_files.has(sound_type)):
		sound_player.stream = sound_files[sound_type]
		sound_player.play()
	else:
		print("Sound type not found: ", sound_type)	
