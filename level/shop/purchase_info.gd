extends Node2D

var puchased_item: ShopItem
var player_wallet
var purchased_item
@onready var coins_left_label = %PlayerWalletCoinsLabel
var coins_image = "[img]res://player/hud-coin.png[/img]" #FIXME move this to assets since it is common now
var outline_prefix="[outline_color=black][outline_size=10]"
var outline_suffix= "[/outline_size][/outline_color]"

func _ready():
	handle_events()

func handle_events():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_CLICKED_SHOP_ITEM, on_purchase_info)

func for_player(_player):
	self.player_wallet = _player.wallet
	coins_left_label.text = coins_image+outline_prefix+" x "+str(player_wallet.coins_nr)+outline_suffix
	return self

# FIXME I want to  use purchase_info like purchase_info.for_player(player).for_item(item) to pass information
# FIXME lets see if it makes even sense
func for_item(_item):
	self.purchased_item = _item
	return self	

# TODO nice design for buy popup
# TODO item information
# FIXME what to do with a background? For now everything is clickable
func on_purchase_info(item: ShopItem):
	show()
	puchased_item = item

func _on_cancel_button_pressed():
	clean_up()

func _on_purchase_button_pressed():
	clean_up()

func clean_up():
	puchased_item = null
	hide()

