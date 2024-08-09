extends CanvasLayer

var game_sound_manager = GameSoundManager.get_instance()
var rich_text_behaviour = RichTextCustomBehaviour.get_instance()
var pausable = PausableNodeBehaviour.new(self)
var tween_behaviour = CustomTweenBehaviour.new(self)

@onready var level_score_label: RichTextLabel = %LevelScore
@onready var wave_info_label: RichTextLabel = %WaveInfo
@onready var enemies_left_label: RichTextLabel = %EnemiesLeft
@onready var player_upgrades_info_label: RichTextLabel = %PlayerUpgradesInfo
@onready var player_guides = %PlayerGuides
@onready var sfx_player = $SFXPlayer

var level_info_color_prefix="[color=green]"
var level_info_color_suffix="[/color]"
var tutorial_repeat = 3

var conversation_in_progress = false
var enemies_left = 0
var player_upgrade_tween: Tween
var wave_info_tween: Tween
var player_guides_tween: Tween

# TODO Refactor all this to be separated as many tiny hud elements, so it would be better organized and reusable in different places all over
func _ready():
	GlobalEventBus.connect(GlobalEventBus.MAIN_MENU_DISPLAYED, hide_hud)
	GlobalEventBus.connect(GlobalEventBus.MAIN_MENU_HIDDEN, conditional_show_hud)
	GlobalEventBus.connect(GlobalEventBus.WAVE_STARTED, on_wave_started)
	GlobalEventBus.connect(GlobalEventBus.WAVE_COMPLETED, on_wave_completed)
	GlobalEventBus.connect(GlobalEventBus.ENEMY_DEATH, on_enemy_death)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_UPGRADED, on_player_upgrade)
	GlobalEventBus.connect(GlobalEventBus.INTERACTION_HINT, show_interaction_tutorial)
	GlobalEventBus.connect(GlobalEventBus.INTERACTION_HINT_HIDE, hide_interaction_tutorial)
	GlobalEventBus.connect(GlobalEventBus.START_CONVERSATION_WITH, hide_hud)
	GlobalEventBus.connect(GlobalEventBus.FINISH_CONVERSATION, show_hud)
	player_upgrades_info_label.modulate.a = 0
	wave_info_label.modulate.a = 0
	player_guides.modulate.a = 0

func hide_hud(arg: String = ""):
	if (arg.length() > 0):
		conversation_in_progress = true
	hide()
	pausable.set_pause(true)

func conditional_show_hud():
	show_hud(conversation_in_progress)

func show_hud(conversation_in_progress: bool = false):
	if(!conversation_in_progress):
		pausable.set_pause(false)
		show()
		self.conversation_in_progress = false	

func on_player_upgrade(msg_translation: String):
	player_upgrade_tween = tween_behaviour.clear_tween(player_upgrade_tween)	
	player_upgrades_info_label.text = rich_text_behaviour.outline_text(level_info_color_prefix+tr(msg_translation)+level_info_color_suffix)
	tween_behaviour.fade_in_out_component(player_upgrades_info_label, player_upgrade_tween)
	game_sound_manager.play_inerrupt_sound(GameSoundManager.Sounds.UPGRADED, sfx_player)

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
	wave_info_tween = tween_behaviour.clear_tween(wave_info_tween)
	wave_info_label.text = rich_text_behaviour.outline_text(tr("HUD_WAVE_COMPLETED").format({"wave_nr":wave_nr}))
	tween_behaviour.fade_in_out_component(wave_info_label, wave_info_tween)

func show_wave_trigger_tutorial():
	if(tutorial_repeat > 0):
		tutorial_repeat -= 1
		var action_key = InputMap.action_get_events("start_wave")[0].as_text()
		var action_key_translation = tr(action_key.to_upper())
		wave_info_label.text = rich_text_behaviour.outline_text(tr("HUD_NEXT_WAVE_TUTORIAL").format({"action_key":action_key_translation}))
		wave_info_tween = tween_behaviour.clear_tween(wave_info_tween)
		tween_behaviour.fade_in_out_component(wave_info_label, wave_info_tween)		
		wave_info_tween.tween_callback(show_wave_trigger_tutorial)
		
func show_interaction_tutorial():
	player_guides_tween = tween_behaviour.clear_tween(player_guides_tween)	
	var action_key = InputMap.action_get_events("interact")[0].as_text()
	var action_key_translation = tr(action_key.to_upper())
	player_guides.text = rich_text_behaviour.outline_text(tr("HUD_INTERACTION_TUTORIAL").format({"action_key":action_key_translation}))
	tween_behaviour.fade_in_component(player_guides, player_guides_tween)	

func hide_interaction_tutorial():
	player_guides_tween = tween_behaviour.clear_tween(player_guides_tween)
	tween_behaviour.fade_out_component(player_guides, player_guides_tween)		
	
func show_wave_started_message(wave_nr):
	wave_info_label.text = rich_text_behaviour.outline_text(tr("HUD_WAVE")+" "+str(wave_nr))
	wave_info_tween = create_tween()
	tween_behaviour.fade_in_out_component(wave_info_label, wave_info_tween)

func show_get_ready_message(wave_nr):
	wave_info_tween = tween_behaviour.clear_tween(wave_info_tween)
	if (wave_nr == 1):
		wave_info_label.text = rich_text_behaviour.outline_text(tr("HUD_GET_READY"))
	tween_behaviour.fade_in_out_component(wave_info_label, wave_info_tween)
	
func on_enemy_death(death_details: EnemyDeathDetails):
	if (enemies_left  > 0 ): 
		enemies_left -= 1
		update_enemies_left_label_text()
	
func update_enemies_left_label_text():
	enemies_left_label.text = rich_text_behaviour.outline_text(tr("HUD_ENEMIES_LEFT")+": "+str(enemies_left))
	
