extends Panel

var tween_behaviour = CustomTweenBehaviour.new(self)
var health_bar_visibility_tween: Tween
@onready var health_bar = $ProgressBar

func _ready():
	handle_events()
	prepare_health_bar()
	
func handle_events():
	GlobalEventBus.connect(GlobalEventBus.BOSS_ENEMY_HP_CHANGED, on_hp_changed)

func prepare_health_bar():
	health_bar.modulate.a = 0

func on_hp_changed(hp):
	update_health_bar(hp)
	if(hp == health_bar.max_value):
		show_health_bar()
	elif(hp <= 0):
		hide_health_bar()

func update_health_bar(hp):
	if(health_bar.max_value == 0):
		health_bar.max_value = hp
	health_bar.value = hp

func show_health_bar():
	health_bar_visibility_tween = tween_behaviour.clear_tween(health_bar_visibility_tween)
	tween_behaviour.fade_in_component(health_bar, health_bar_visibility_tween, 0.4)	

func hide_health_bar():
	health_bar_visibility_tween = tween_behaviour.clear_tween(health_bar_visibility_tween)
	tween_behaviour.fade_out_component(health_bar, health_bar_visibility_tween, 0.5)	
