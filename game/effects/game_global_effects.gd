extends Node2D

@onready var bullet_timer = $BulletTimer

@onready var bullet_time_filter_container = $BFilterContainer
@onready var invert_filter = $BFilterContainer/InvertFilter
@onready var wave_line_filter = $BFilterContainer/BackBufferCopy/WaveLineFilter
@onready var flash_color_rect = $FlashColorRect
@onready var effects_audio_player = $EffectsAudioStreamPlayer
var sound_manager = GameSoundManager.get_instance()
var drinking_audio = GameSoundManager.Sounds.DRINKING

const INVERT_SHADER_PATH = "res://shaders/invert.gdshader"
const WAVE_LINE_SHADER_PATH = "res://shaders/wave_line.gdshader"
var invert_filter_shader_material: ShaderMaterial
var wave_line_filter_shader_material: ShaderMaterial
var bullet_time_tween: Tween
var flash_effect_tween: Tween

func _ready():
	handle_events()
	load_shaders()
	prepare_effects()

func handle_events():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_CONSUMED_ITEM, on_player_consumed_item)

func load_shaders():
	var invert_shader = load(INVERT_SHADER_PATH)
	invert_filter_shader_material = ShaderMaterial.new()
	invert_filter_shader_material.shader = invert_shader
	
	var wave_line_shader = load(WAVE_LINE_SHADER_PATH)
	wave_line_filter_shader_material = ShaderMaterial.new()
	wave_line_filter_shader_material.shader = wave_line_shader

func prepare_effects():
	flash_color_rect.modulate.a = 0

func on_player_consumed_item(item: ShopItem):
	match item.id:
		Item.ItemName.CATNIP:
			slow_time()
		Item.ItemName.WATER:
			on_heal()	
	
func slow_time():
	if (bullet_timer.is_stopped()):
		invert_filter.material = invert_filter_shader_material
		wave_line_filter.material = wave_line_filter_shader_material
		bullet_time_filter_container.show()
		bullet_time_tween = clear_paralel_tween(bullet_time_tween)
		bullet_time_tween.tween_property(Engine, "time_scale", 0.5, 0.5)
		bullet_time_tween.tween_property(AudioServer, "playback_speed_scale", 0.5, 0.5)
		bullet_time_tween.tween_method(set_bullet_time_shader_strength, 0.0, 1.0, 0.5)
		bullet_timer.wait_time = 4
		bullet_timer.start()
		bullet_timer.connect("timeout", reset_time_speed)
		
func reset_time_speed():
	bullet_timer.stop()
	bullet_time_tween = clear_paralel_tween(bullet_time_tween)
	bullet_time_tween.tween_property(Engine, "time_scale", 1, 0.5)
	bullet_time_tween.tween_property(AudioServer, "playback_speed_scale", 1, 0.5)
	bullet_time_tween.tween_method(clear_bullet_time_shaders, 1.0, 0.0, 0.5)
	bullet_timer.disconnect("timeout", reset_time_speed)

func clear_paralel_tween(tween: Tween)-> Tween:
	if (tween != null):
		tween.kill()
	return create_tween().set_parallel(true)

func clear_tween(tween: Tween)-> Tween:
	if (tween != null):
		tween.kill()
	return create_tween()

func set_bullet_time_shader_strength(value: float):
	invert_filter.material.set_shader_parameter("strength", value)
	wave_line_filter.material.set_shader_parameter("strength", value)
	

func clear_bullet_time_shaders(value: float):
	set_bullet_time_shader_strength(value)
	if (value == 0.0):
		bullet_time_filter_container.hide()
		invert_filter.material = null
		wave_line_filter.material = null


func on_heal():
	flash_color_rect.show()
	flash_effect_tween = clear_tween(flash_effect_tween)
	sound_manager.play_inerrupt_sound(drinking_audio, effects_audio_player)
	flash_effect_tween.tween_property(flash_color_rect, "modulate:a", 0.75, 0.15)
	flash_effect_tween.tween_property(flash_color_rect, "modulate:a", 0, 0.15)
	flash_effect_tween.tween_callback(flash_color_rect.hide)
