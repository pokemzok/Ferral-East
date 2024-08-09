extends VBoxContainer

@onready var upgrades_label: RichTextLabel = $UpgradesLabel
@onready var sfx_player = $SFXPlayer
var game_sound_manager = GameSoundManager.get_instance()
var rich_text_behaviour = RichTextCustomBehaviour.get_instance()
var tween_behaviour = CustomTweenBehaviour.new(self)
var player_upgrade_tween: Tween

var level_info_color_prefix="[color=green]"
var level_info_color_suffix="[/color]"

func _ready():
	upgrades_setup()
	handle_events()

func upgrades_setup():
	upgrades_label.modulate.a = 0

func handle_events():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_UPGRADED, on_player_upgrade)

func on_player_upgrade(msg_translation: String):
	player_upgrade_tween = tween_behaviour.clear_tween(player_upgrade_tween)	
	upgrades_label.text = rich_text_behaviour.outline_text(level_info_color_prefix+tr(msg_translation)+level_info_color_suffix)
	tween_behaviour.fade_in_out_component(upgrades_label, player_upgrade_tween)
	game_sound_manager.play_inerrupt_sound(GameSoundManager.Sounds.UPGRADED, sfx_player)		
