extends CanvasLayer

var health_point_res = preload("res://player/Health.png")

@onready var level_score_label: RichTextLabel = %LevelScore
@onready var last_enemy_points_label: RichTextLabel = %LastEnemyPoints
@onready var wave_info_label: RichTextLabel = %WaveInfo
@onready var enemies_left_label: RichTextLabel = %EnemiesLeft
@onready var projectiles_left_label: RichTextLabel = %ProjectilesLeft

var projectiles_image= "[img]res://player/hud-bullet.png[/img]"
var outline_prefix="[outline_color=black][outline_size=10]"
var outline_suffix= "[/outline_size][/outline_color]"
var tutorial_repeat = 3

var enemy_points_colors = {
	1: Color("#ffffff", 0),
	2: Color("#00ff00", 0), 
	3: Color("#6bc3fe", 0),
	4: Color("#f25932", 0),
	5: Color("#833e19",0),
	6: Color("#b22727",0),
	7: Color("#9c0000",0),
	8: Color("#9c4af3",0)
}
var enemies_left = 0
var original_color: Color
var original_color_transparent: Color
var enemy_points_tween: Tween
var level_score_tween: Tween
var wave_info_tween: Tween

func _ready():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_HP_CHANGED, on_hp_changed)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_USED_PROJECTILE_WEAPON, on_projectile_weapon_used)	
	GlobalEventBus.connect(GlobalEventBus.MAIN_MENU_DISPLAYED, on_menu_displayed)
	GlobalEventBus.connect(GlobalEventBus.MAIN_MENU_HIDDEN, on_menu_hidden)
	GlobalEventBus.connect(GlobalEventBus.SCORE_CHANGED, on_score_changed)
	GlobalEventBus.connect(GlobalEventBus.WAVE_STARTED, on_wave_started)
	GlobalEventBus.connect(GlobalEventBus.WAVE_COMPLETED, on_wave_completed)
	GlobalEventBus.connect(GlobalEventBus.ENEMY_DEATH, on_enemy_death)
	original_color_transparent = Color(last_enemy_points_label.modulate, 0)
	original_color = Color(last_enemy_points_label.modulate, 1)
	last_enemy_points_label.modulate.a = 0
	wave_info_label.modulate.a = 0
	level_score_label.text = outline_prefix+tr("HUD_SCORE")+": " + str(0)+outline_suffix	
	
func on_hp_changed(hp):
	clear_hearts()
	for i in range(hp):
		add_hp()

func on_projectile_weapon_used(projectiles_left):
	projectiles_left_label.text = projectiles_image+outline_prefix+"x "+str(projectiles_left)+outline_suffix

func on_menu_displayed():
	hide()

func on_menu_hidden():
	show()

func clear_hearts():
	var health_container = $HealthContainer
	while health_container.get_child_count() > 0:
		var heart = health_container.get_child(0)
		health_container.remove_child(heart)

func add_hp():
	var health_point_icon = TextureRect.new()
	health_point_icon.texture = health_point_res
	$HealthContainer.add_child(health_point_icon)

func on_score_changed(details: ScoreDetails):
	level_score_update(details)
	enemy_points_update(details)

func level_score_update(details: ScoreDetails):
	if (level_score_tween != null):
		level_score_tween.kill()
	level_score_label.text = outline_prefix+tr("HUD_SCORE")+": " + str(details.score)+outline_suffix	
	level_score_tween = create_tween()
	level_score_tween.tween_property(level_score_label, "scale", Vector2(1.1, 1.1), 0.15)
	level_score_tween.tween_property(level_score_label, "scale", Vector2(1, 1), 0.15)
	
func enemy_points_update(details: ScoreDetails):
	if (enemy_points_tween != null):
		enemy_points_tween.kill()
	var color = original_color_transparent
	if (enemy_points_colors.has(details.score_multiplier)):
		color = enemy_points_colors[details.score_multiplier]
	last_enemy_points_label.modulate = Color(color,1)
	last_enemy_points_label.text  = outline_prefix+str(details.enemy_value)+" x "+str(details.score_multiplier)+outline_suffix
	enemy_points_tween = create_tween()
	enemy_points_tween.tween_property(last_enemy_points_label, "scale", Vector2(1.25, 1.25), 0.15)
	enemy_points_tween.tween_property(last_enemy_points_label, "scale", Vector2(1, 1), 0.15)
	enemy_points_tween.tween_property(last_enemy_points_label, "modulate", color, 2)

func on_wave_started(wave_nr, enemies_left):
	tutorial_repeat = 0
	if(wave_info_tween != null):
		wave_info_tween.stop()
		wave_info_tween.kill()
	self.enemies_left = enemies_left
	enemies_left_label.show()
	update_enemies_left_label_text()	
	show_wave_started_message(wave_nr)	
	if (wave_nr == 1):
		wave_info_tween.tween_callback(show_get_ready_message.bind(wave_nr))

func on_wave_completed(wave_nr):
	if(wave_nr < 3):
		tutorial_repeat = 3
	if(wave_info_tween != null):
		wave_info_tween.kill()
	wave_info_label.text = outline_prefix+tr("HUD_WAVE_COMPLETED").format({"wave_nr":wave_nr})+outline_suffix
	wave_info_tween = create_tween()
	fade_in_out_component(wave_info_label, wave_info_tween)
	wave_info_tween.tween_callback(show_wave_trigger_tutorial)

func show_wave_trigger_tutorial():
	if(tutorial_repeat > 0):
		tutorial_repeat -= 1
		var action_key = InputMap.action_get_events("action")[0].as_text()
		var action_key_translation = tr(action_key.to_upper())
		wave_info_label.text = outline_prefix+tr("HUD_NEXT_WAVE_TUTORIAL").format({"action_key":action_key_translation})+outline_suffix
		wave_info_tween = create_tween()
		fade_in_out_component(wave_info_label, wave_info_tween)		
		wave_info_tween.tween_callback(show_wave_trigger_tutorial)
	
func show_wave_started_message(wave_nr):
	wave_info_label.text = outline_prefix+tr("HUD_WAVE")+" "+str(wave_nr)+outline_suffix
	wave_info_tween = create_tween()
	fade_in_out_component(wave_info_label, wave_info_tween)

func show_get_ready_message(wave_nr):
	wave_info_tween = create_tween()
	if (wave_nr == 1):
		wave_info_label.text = outline_prefix+tr("HUD_GET_READY")+outline_suffix
	fade_in_out_component(wave_info_label, wave_info_tween)
	
func fade_in_out_component(component: Node, component_tween: Tween):
	component_tween.tween_property(component, "modulate", original_color, 1)
	component_tween.tween_property(component, "modulate", original_color, 2)
	component_tween.tween_property(component, "modulate", original_color_transparent, 2)

func on_enemy_death(type, score):
	if (enemies_left  > 0 ): 
		enemies_left -= 1
		update_enemies_left_label_text()
	
func update_enemies_left_label_text():
	enemies_left_label.text = outline_prefix+tr("HUD_ENEMIES_LEFT")+": "+str(enemies_left)+outline_suffix
	
