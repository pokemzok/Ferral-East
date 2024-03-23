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
	PLAYER_RUN,
	SURBI_GRUNT_1,
	SURBI_GRUNT_2,
	SURBI_GRUNT_3,
	SURBI_GRUNT_4,
	SURBI_DEATH,
	BULLET_HIT_BODY
}

var zombie_voices = ArrayCollection.new([Sounds.ZOMBIE_VOICE_1, Sounds.ZOMBIE_VOICE_2, Sounds.ZOMBIE_VOICE_3, Sounds.ZOMBIE_VOICE_4])
var zombie_death = ArrayCollection.new([Sounds.ZOMBIE_DEATH_1, Sounds.ZOMBIE_DEATH_2, Sounds.ZOMBIE_DEATH_3, Sounds.ZOMBIE_DEATH_4])
var surbi_grunts = ArrayCollection.new([Sounds.SURBI_GRUNT_1, Sounds.SURBI_GRUNT_2,  Sounds.SURBI_GRUNT_3,  Sounds.SURBI_GRUNT_4])

var sound_files = {
	Sounds.REVOLVER_RELOAD: preload("res://audio/weapons/revolver-reload-shorter.wav"),
	Sounds.REVOLVER_SHOOT: preload("res://audio/weapons/revolver-shot.mp3"),
	Sounds.BULLET_HIT_BODY: preload("res://audio/weapons/bullet-hit-body.mp3"),
	Sounds.ZOMBIE_VOICE_1: preload("res://audio/enemies/zombie/zombie-voice-1.mp3"),
	Sounds.ZOMBIE_VOICE_2: preload("res://audio/enemies/zombie/zombie-voice-2.mp3"),
	Sounds.ZOMBIE_VOICE_3: preload("res://audio/enemies/zombie/zombie-voice-3.mp3"),
	Sounds.ZOMBIE_VOICE_4: preload("res://audio/enemies/zombie/zombie-voice-4.mp3"),
	Sounds.ZOMBIE_DEATH_1: preload("res://audio/enemies/zombie/zombie-death-1.mp3"),
	Sounds.ZOMBIE_DEATH_2: preload("res://audio/enemies/zombie/zombie-death-2.mp3"),
	Sounds.ZOMBIE_DEATH_3: preload("res://audio/enemies/zombie/zombie-death-3.mp3"),
	Sounds.ZOMBIE_DEATH_4: preload("res://audio/enemies/zombie/zombie-death-4.mp3"),
	Sounds.PLAYER_RUN: preload("res://audio/player/running-on-grass.mp3"),
	Sounds.SURBI_GRUNT_1: preload("res://audio/player/surbi/grunt-1.wav"),
	Sounds.SURBI_GRUNT_2: preload("res://audio/player/surbi/grunt-2.wav"),
	Sounds.SURBI_GRUNT_3: preload("res://audio/player/surbi/grunt-3.wav"),
	Sounds.SURBI_GRUNT_4: preload("res://audio/player/surbi/grunt-4.wav"),
	Sounds.SURBI_DEATH: preload("res://audio/player/surbi/death.wav"),
}

static var instance = null

static func get_instance():
	if instance == null:
		instance = GameSoundManager.new()
		instance.name = "GameAudioManager"
		instance.add_to_group("singleton")
	return instance	

func play_sound(sound_type: Sounds, sound_player: Node):
	if (!sound_player.is_playing()):
		if  (sound_files.has(sound_type)):
			sound_player.stream = sound_files[sound_type]
			sound_player.play()
		else:
			print("Sound type not found: ", sound_type)	
