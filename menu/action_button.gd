extends Button

@export var action: String = "move_up"
var is_action_during_remapping = false

func _ready():
	set_process_unhandled_key_input(false)
	set_process_unhandled_input(false)
	display_key()

func display_key():
	text = InputMap.action_get_events(action)[0].as_text()
	
func remap_action_to(event):
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	Persistence.config.set_value("Controls",  action, event)
	Persistence.save_data()
	text = event.as_text()

func _on_pressed():
	if (!is_action_during_remapping):	
		is_action_during_remapping = true
		set_process_unhandled_key_input(true)
		set_process_unhandled_input(true)
		text = "press any key"
	else:
		var left_click_event = create_left_mouse_click_event()	
		_unhandled_input(left_click_event)

func create_left_mouse_click_event():
	var event = InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	event.position = Vector2(0, 0)
	return event

func _unhandled_key_input(event):
	unandled_input(event)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		unandled_input(event)

func unandled_input(event):
	remap_action_to(event)
	set_process_unhandled_key_input(false)
	set_process_unhandled_input(false)
	release_focus()
	is_action_during_remapping = false
