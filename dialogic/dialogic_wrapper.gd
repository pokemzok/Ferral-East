extends Node

func _ready():
	GlobalEventBus.connect(GlobalEventBus.TRADER_DAMAGED, on_trader_damaged)
	GlobalEventBus.connect(GlobalEventBus.START_CONVERSATION_WITH, on_start_conversation_with)

func on_trader_damaged(trader_name: String):
	Dialogic.VAR.trader.player_attacking_trader_count += 1

func on_start_conversation_with(character_name: String):
	if (Dialogic.current_timeline != null):
		return
	Dialogic.timeline_ended.connect(on_timeline_ended)		
	Dialogic.start(character_name+"_timeline")

func on_timeline_ended():
	GlobalEventBus.finish_conversation.emit()
	Dialogic.timeline_ended.disconnect(on_timeline_ended)		

func toggle_dialogs():
	if (Dialogic.current_timeline != null):
		var is_menu_visible = get_tree().paused 
		var layout := Dialogic.Styles.get_layout_node()	
		if (is_menu_visible):
			layout.hide()
			Dialogic.paused = true	
		else:
			Dialogic.paused = false	
			layout.show()

func clear():
	if (Dialogic.current_timeline != null):
		Dialogic.timeline_ended.disconnect(on_timeline_ended)	
		Dialogic.end_timeline()
		Dialogic.paused = false			
