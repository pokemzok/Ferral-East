extends Node

@onready var delay_timer = $DelayTimer

func _ready():
	GlobalEventBus.connect(GlobalEventBus.WAVE_COMPLETED, on_wave_completed)


func on_wave_completed(wave_index):
	delay_timer.start()
	delay_timer.connect("timeout", wave_monolog.bind(wave_index))
	

func wave_monolog(wave_index):
	match wave_index:
		1:
			first_wave_monolog()
		2: 
			second_wave_monolog()
		4:
			fourth_wave_monolog()
		6:
			sixth_wave_monolog()
		9:
			nineth_wave_monolog()				
		_:
			pass	
	delay_timer.disconnect("timeout", wave_monolog)			
	
func first_wave_monolog():
	var action_key = InputMap.action_get_events("start_wave")[0].as_text()
	var action_key_translation = tr(action_key.to_upper())
	var player_thoughts = tr("SURBI_WAVE1_MONOLOG").format({"action_key":action_key_translation})
	GlobalEventBus.player_monolog.emit(player_thoughts)	

func second_wave_monolog():
	GlobalEventBus.player_monolog.emit(tr("SURBI_WAVE2_MONOLOG"))	

func fourth_wave_monolog():
	GlobalEventBus.player_monolog.emit(tr("SURBI_WAVE4_MONOLOG"))
	
func sixth_wave_monolog():
	GlobalEventBus.player_monolog.emit(tr("SURBI_WAVE6_MONOLOG"))			

func nineth_wave_monolog():
	GlobalEventBus.player_monolog.emit(tr("SURBI_WAVE9_MONOLOG"))
