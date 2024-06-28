extends StaticBody2D

@onready var animations = $AnimatedSprite2D

static var character_name = CharacterNames.SHARIK

static var conversation_timeline = "Sharik_exit_shop"
# TODO:
# 1. Refactor dialogic,  enhance current API to be aware of user state (like character in shop or something)
# 3. Finish implementing buying of those three items (also make them look different on hover (I want Sharik highlight style).
# 4. Something is wrong with a sound system (it triggers when player exits shop and it should not).
# 5. Clicking Escape just after entering shop results in dialogic bug, give some cooldown periods for buttons. 

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
			GlobalEventBus.start_conversation_with.emit(conversation_timeline)
