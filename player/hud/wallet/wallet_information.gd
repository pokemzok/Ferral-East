extends HBoxContainer

@onready var coins_left_label: RichTextLabel = $CoinsLeft
var rich_text_behaviour = RichTextCustomBehaviour.get_instance()
var coins_image = "[img]res://player/hud/wallet/coin.png[/img]"

func _ready():
	handle_events()

func handle_events():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_COLLECTED_COINS, on_collected_coins)

func on_collected_coins(coins_nr):
	coins_left_label.show()
	coins_left_label.text = coins_image+rich_text_behaviour.outline_text(" x "+str(coins_nr))
		
