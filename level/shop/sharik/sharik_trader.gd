extends StaticBody2D

@onready var animations = $AnimatedSprite2D

static var conversation_timeline = "Sharik_exit_shop"
# TODO:
# 1. Make input pickable only after the guys are finished talking
# 2. Refactor dialogic, to accept timelines instead of character name or enhance current API to be aware of user state (like character in shopor something)
# 3. Refactor dialogic - remove unnecessary functions (I don't  need buble style dialogs).
# 4. Finish implementing buying of those three items (also make them look different on hover (I want Sharik highlight style).
 
func _ready():
	input_pickable = true

func _on_mouse_entered():
	animations.play("highlight")

func _on_mouse_exited():
	animations.play("default")


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			GlobalEventBus.start_conversation_with.emit(conversation_timeline)
