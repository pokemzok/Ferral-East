extends Control

@onready var wave_info_label: RichTextLabel = %WaveMsg
@onready var enemies_left_label: RichTextLabel = %EnemiesLeft

var enemies_left = 0
var rich_text_behaviour = RichTextCustomBehaviour.get_instance()
var tween_behaviour = CustomTweenBehaviour.new(self)
var wave_info_tween: Tween

func _ready():
	wave_info_setup()
	handle_events()

func wave_info_setup():
	wave_info_label.modulate.a = 0

func handle_events():
	GlobalEventBus.connect(GlobalEventBus.WAVE_STARTED, on_wave_started)
	GlobalEventBus.connect(GlobalEventBus.WAVE_COMPLETED, on_wave_completed)
	GlobalEventBus.connect(GlobalEventBus.ENEMY_DEATH, on_enemy_death)

func on_wave_started(wave_nr, enemies_left):
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
	wave_info_tween = tween_behaviour.clear_tween(wave_info_tween)
	wave_info_label.text = rich_text_behaviour.outline_text(tr("HUD_WAVE_COMPLETED").format({"wave_nr":wave_nr}))
	tween_behaviour.fade_in_out_component(wave_info_label, wave_info_tween)
		
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
	
		
