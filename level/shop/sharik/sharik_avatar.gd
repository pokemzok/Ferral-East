extends StaticBody2D

@onready var animations = $AnimatedSprite2D

static var character_name = CharacterNames.SHARIK

# TODO:
# 1. Check if dialogic works as suposed (had some problem with a timelines and didn't had time to test)
# 2. Finish implementing buying of those three items (also make them look different on hover.

func _ready():
	connect_events()

func connect_events():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_READY_TO_BUY, on_player_ready_to_buy)

func on_player_ready_to_buy():
	input_pickable = true
	
func _on_mouse_entered():
	animations.play("highlight")

func _on_mouse_exited():
	animations.play("default")

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			input_pickable = false
			GlobalEventBus.start_conversation_with.emit(character_name)