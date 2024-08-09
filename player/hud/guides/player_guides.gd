extends HBoxContainer


@onready var player_guides = $PlayerGuides

var rich_text_behaviour = RichTextCustomBehaviour.get_instance()
var tween_behaviour = CustomTweenBehaviour.new(self)
var player_guides_tween: Tween


func _ready():
	prepare_label()
	handle_events()

func prepare_label():
	player_guides.modulate.a = 0

func handle_events():
	GlobalEventBus.connect(GlobalEventBus.INTERACTION_HINT, show_interaction_tutorial)
	GlobalEventBus.connect(GlobalEventBus.INTERACTION_HINT_HIDE, hide_tutorial)

func show_interaction_tutorial():
	var action_key = InputMap.action_get_events("interact")[0].as_text()
	var action_key_translation = tr(action_key.to_upper())
	show_tutorial(tr("HUD_INTERACTION_TUTORIAL").format({"action_key":action_key_translation}))	

func show_tutorial(tutorial_text: String):
	player_guides_tween = tween_behaviour.clear_tween(player_guides_tween)	
	player_guides.text = rich_text_behaviour.outline_text(tutorial_text)
	tween_behaviour.fade_in_component(player_guides, player_guides_tween)	

func hide_tutorial():
	player_guides_tween = tween_behaviour.clear_tween(player_guides_tween)
	tween_behaviour.fade_out_component(player_guides, player_guides_tween)		
			
