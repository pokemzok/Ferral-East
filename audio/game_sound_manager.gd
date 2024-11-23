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
	RUN,
	PICKUP_ITEM,
	PICKUP_EVIL_ITEM,
	SURBI_GRUNT_1,
	SURBI_GRUNT_2,
	SURBI_GRUNT_3,
	SURBI_GRUNT_4,
	SURBI_DEATH,
	KILT_GRUNT,
	KILT_DEATH,
	BULLET_HIT_BODY,
	DRUMS,
	WAVE_END,
	UPGRADED,
	TELEPORT,
	WARP,
	PURCHASE,
	ROTATE_INVENTORY,
	DRINKING
}
enum Music {
	SLOW_LOOP_1,
	SLOW_LOOP_2,
	FAST_LOOP_1,
	FAST_LOOP_2,
	FAST_LOOP_3,
	FAST_LOOP_4,
	LONG_LOOP_1,
	LONG_LOOP_2,
	REST_LOOP_2,
	GAME_OVER,
	WAVE_END
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
	Sounds.RUN: preload("res://audio/player/running-on-grass.mp3"),
	Sounds.PICKUP_ITEM: preload("res://audio/effects/pickup.mp3"),
	Sounds.PICKUP_EVIL_ITEM: preload("res://audio/effects/evil_item_pickup.wav"),
	Sounds.SURBI_GRUNT_1: preload("res://audio/player/surbi/grunt-1.wav"),
	Sounds.SURBI_GRUNT_2: preload("res://audio/player/surbi/grunt-2.wav"),
	Sounds.SURBI_GRUNT_3: preload("res://audio/player/surbi/grunt-3.wav"),
	Sounds.SURBI_GRUNT_4: preload("res://audio/player/surbi/grunt-4.wav"),
	Sounds.SURBI_DEATH: preload("res://audio/player/surbi/death.wav"),
	Sounds.DRUMS: preload("res://audio/effects/drum-hit.wav"),
	Sounds.WAVE_END: preload("res://audio/effects/whistle.wav"),
	Sounds.UPGRADED: preload("res://audio/effects/level_up.wav"),
	Sounds.TELEPORT: preload("res://audio/effects/teleport.mp3"),
	Sounds.WARP: preload("res://audio/effects/warp.mp3"),
	Sounds.PURCHASE: preload("res://audio/effects/purchase.mp3"),
	Sounds.ROTATE_INVENTORY: preload("res://audio/effects/rotate_inventory.mp3"),
	Sounds.DRINKING: preload("res://audio/effects/drinking.mp3")
}

var kilt_res = {
	Sounds.KILT_GRUNT: "res://audio/enemies/kilt/kilt-grunt.wav",
	Sounds.KILT_DEATH: "res://audio/enemies/kilt/kilt-death.wav"
}

var music_res = {
	Music.SLOW_LOOP_1: "res://audio/background_music/feral-east-wave-slow.wav",
	Music.SLOW_LOOP_2: "res://audio/background_music/feral-east-wave-slow-2.wav",
	Music.FAST_LOOP_1: "res://audio/background_music/feral-east-wave-fast.wav",
	Music.FAST_LOOP_2: "res://audio/background_music/feral-east-wave-fast-2.wav",
	Music.FAST_LOOP_3: "res://audio/background_music/feral-east-wave-fast-3.wav",
	Music.FAST_LOOP_4: "res://audio/background_music/feral-east-wave-fast-4.wav",
	Music.LONG_LOOP_1: "res://audio/background_music/feral-east-wave-long.wav",
	Music.LONG_LOOP_2: "res://audio/background_music/feral-east-wave-long-2.wav",
	Music.REST_LOOP_2: "res://audio/background_music/feral-east-resting-2.wav",
	Music.GAME_OVER: "res://audio/background_music/feral-east-game-over.wav",
	Music.WAVE_END: "res://audio/background_music/feral-east-wave-end.wav"
}

var slow_music_loops_keys = [Music.SLOW_LOOP_1, Music.SLOW_LOOP_2]
var fast_music_loops_keys = [Music.FAST_LOOP_1, Music.FAST_LOOP_2, Music.FAST_LOOP_3, Music.FAST_LOOP_4]
var long_music_loops_keys = [Music.LONG_LOOP_1, Music.LONG_LOOP_2]
var rest_music_loops_keys = [Music.REST_LOOP_2]
var game_over_loops_keys = [Music.GAME_OVER]
var victory_loops_keys = [Music.WAVE_END]

static var instance = null

static func get_instance() -> GameSoundManager:
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

func play_inerrupt_sound(sound_type: Sounds, sound_player: Node):
	if  (sound_files.has(sound_type)):
		if (sound_player.is_playing()):
			sound_player.stop()
		sound_player.stream = sound_files[sound_type]
		sound_player.play()
	else:
		print("Sound type not found: ", sound_type)	

func play_interrupt_sound_resource(res, sound_player: Node):
		if (sound_player.is_playing()):
			sound_player.stop()
		sound_player.stream = res
		
		sound_player.play()

func survival_music_keys() -> Array:
	if(slow_music_loops_keys.is_empty() || fast_music_loops_keys.is_empty() || long_music_loops_keys.is_empty()):
		return []
	else:	
		var slow_music_collection = ArrayCollection.new(slow_music_loops_keys)
		var fast_music_collection = ArrayCollection.new(fast_music_loops_keys)
		var long_music_collection = ArrayCollection.new(long_music_loops_keys)
		var survival_keys = slow_music_collection.random_elements(slow_music_collection.size())
		survival_keys += fast_music_collection.random_elements(fast_music_collection.size())
		survival_keys += long_music_collection.random_elements(long_music_collection.size())
		return survival_keys
	
