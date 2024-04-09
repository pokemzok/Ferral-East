extends TabBar

@onready var music_bus_player = $MusicBusPlayer
@onready var sfx_bus_player = $SFXBusPlayer
@onready var voices_bus_player = $VoicesBusPlayer

var sound_manager = GameSoundManager.get_instance()
var music_example = GameSoundManager.Sounds.DRUMS
var sfx_example = GameSoundManager.Sounds.REVOLVER_SHOOT
var voices_example = GameSoundManager.Sounds.ZOMBIE_DEATH_1

func _ready():
	disconnect_signals()
	%Master.value = Persistence.config.get_value("Audio", '0')
	AudioServer.set_bus_volume_db(0, linear_to_db(%Master.value))
	
	%Music.value = Persistence.config.get_value("Audio", '1')
	AudioServer.set_bus_volume_db(1, linear_to_db(%Music.value))
	
	%SFX.value = Persistence.config.get_value("Audio", '2')
	AudioServer.set_bus_volume_db(2, linear_to_db(%SFX.value))
	
	%Voices.value = Persistence.config.get_value("Audio", '3')
	AudioServer.set_bus_volume_db(3, linear_to_db(%Voices.value))
	connect_signals()

func _on_master_value_changed(value):
	music_bus_player.stop()
	sfx_bus_player.stop()
	voices_bus_player.stop()
	set_volume(0, value)
	sound_manager.play_sound(music_example, music_bus_player)
	sound_manager.play_sound(sfx_example, sfx_bus_player)
	sound_manager.play_sound(voices_example, voices_bus_player)

func _on_music_value_changed(value):
	music_bus_player.stop()
	set_volume(1, value)
	sound_manager.play_sound(music_example, music_bus_player)


func _on_sfx_value_changed(value):
	sfx_bus_player.stop()
	set_volume(2, value)
	sound_manager.play_sound(sfx_example, sfx_bus_player)

func _on_voices_value_changed(value):
	voices_bus_player.stop()
	set_volume(3, value)
	sound_manager.play_sound(voices_example, voices_bus_player)

func set_volume(idx, value):
	AudioServer.set_bus_volume_db(idx, linear_to_db(value))
	Persistence.config.set_value("Audio", str(idx), value)
	Persistence.save_data()

func disconnect_signals():
	%Master.disconnect("value_changed", _on_master_value_changed)
	%Music.disconnect("value_changed", _on_music_value_changed)
	%SFX.disconnect("value_changed", _on_sfx_value_changed)
	%Voices.disconnect("value_changed", _on_voices_value_changed)

func connect_signals():
	%Master.connect("value_changed", _on_master_value_changed)
	%Music.connect("value_changed", _on_music_value_changed)
	%SFX.connect("value_changed", _on_sfx_value_changed)
	%Voices.connect("value_changed", _on_voices_value_changed)
