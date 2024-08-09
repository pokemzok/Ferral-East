extends CanvasLayer

var game_sound_manager = GameSoundManager.get_instance()
var rich_text_behaviour = RichTextCustomBehaviour.get_instance()
var pausable = PausableNodeBehaviour.new(self)
var tween_behaviour = CustomTweenBehaviour.new(self)

@onready var level_score_label: RichTextLabel = %LevelScore
@onready var player_upgrades_info_label: RichTextLabel = %PlayerUpgradesInfo
@onready var sfx_player = $SFXPlayer

var level_info_color_prefix="[color=green]"
var level_info_color_suffix="[/color]"

var conversation_in_progress = false
var player_upgrade_tween: Tween

# TODO Refactor all this to be separated as many tiny hud elements, so it would be better organized and reusable in different places all over
func _ready():
	GlobalEventBus.connect(GlobalEventBus.MAIN_MENU_DISPLAYED, hide_hud)
	GlobalEventBus.connect(GlobalEventBus.MAIN_MENU_HIDDEN, conditional_show_hud)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_UPGRADED, on_player_upgrade)
	GlobalEventBus.connect(GlobalEventBus.START_CONVERSATION_WITH, hide_hud)
	GlobalEventBus.connect(GlobalEventBus.FINISH_CONVERSATION, show_hud)
	player_upgrades_info_label.modulate.a = 0

func hide_hud(arg: String = ""):
	if (arg.length() > 0):
		conversation_in_progress = true
	hide()
	pausable.set_pause(true)

func conditional_show_hud():
	show_hud(conversation_in_progress)

func show_hud(conversation_in_progress: bool = false):
	if(!conversation_in_progress):
		pausable.set_pause(false)
		show()
		self.conversation_in_progress = false	

func on_player_upgrade(msg_translation: String):
	player_upgrade_tween = tween_behaviour.clear_tween(player_upgrade_tween)	
	player_upgrades_info_label.text = rich_text_behaviour.outline_text(level_info_color_prefix+tr(msg_translation)+level_info_color_suffix)
	tween_behaviour.fade_in_out_component(player_upgrades_info_label, player_upgrade_tween)
	game_sound_manager.play_inerrupt_sound(GameSoundManager.Sounds.UPGRADED, sfx_player)

