extends Node

static var warp_locations = {
	LevelManager.Levels.SHARIK_SHOP: GlobalEventBus.player_enters_shop
}

func _ready():
	GlobalEventBus.connect(GlobalEventBus.TRADER_DAMAGED, on_trader_damaged)
	GlobalEventBus.connect(GlobalEventBus.START_CONVERSATION_WITH, on_start_conversation_with)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_ENTERS_SHOP, on_enered_shop)
	Dialogic.signal_event.connect(_on_dialogic_signal)

func on_trader_damaged(trader_name: String):
	Dialogic.VAR.player.attacked_trader_count += 1

func on_enered_shop(character_name: String):
	on_start_conversation_with(character_name+"_shop")

func on_start_conversation_with(character_name: String):
	Dialogic.Styles.load_style("textbox")
	if (Dialogic.current_timeline != null):
		return
	Dialogic.timeline_ended.connect(on_timeline_ended)
	var location = PlayerLog.current_location	
	Dialogic.start(character_name+"_"+location+"_timeline")

func on_timeline_ended():
	GlobalEventBus.finish_conversation.emit()
	Dialogic.timeline_ended.disconnect(on_timeline_ended)		

func toggle_dialogs():
	if (Dialogic.current_timeline != null):
		var is_menu_visible = get_tree().paused 
		if (is_menu_visible):
			hide_dialogs()
		else:
			show_dialogs()

func hide_dialogs():
	var layout := Dialogic.Styles.get_layout_node()	
	layout.hide()		
	Dialogic.paused = true	

func show_dialogs():
	var layout := Dialogic.Styles.get_layout_node()	
	Dialogic.paused = false	
	layout.show()

func clear():
	if (Dialogic.current_timeline != null):
		Dialogic.timeline_ended.disconnect(on_timeline_ended)	
		Dialogic.end_timeline()
		Dialogic.paused = false		
	reset_all_params()		

func reset_all_params():
	Dialogic.VAR.reset()

func _on_dialogic_signal(arg: String):
	var signal_name = arg.to_lower()
	if (GlobalEventBus.has_signal(signal_name)):
		GlobalEventBus.emit_signal_for(signal_name)
	else:	
		var enum_value = LevelManager.Levels.get(arg)
		if(warp_locations.has(enum_value)):
			warp_locations.get(enum_value).emit(enum_value)
	
