extends StaticBody2D

@onready var animations = $AnimatedSprite2D

static var character_name = CharacterNames.SHARIK

# TODO:
# 1. Finish implementing buying of those three items.
# 2. Change textures for revolver_parts (it might be even called broken revolver).

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
			GlobalEventBus.start_interaction_with.emit(character_name)
