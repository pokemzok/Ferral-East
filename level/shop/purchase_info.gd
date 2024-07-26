extends Node2D

var purchased_item: ShopItem
var player_wallet

@onready var coins_left_label = %PlayerWalletCoinsLabel
@onready var item_name_label = %ItemNameLabel
@onready var item_price_label = %ItemPriceLabel
@onready var item_description_label = %ItemDescriptionLabel

var coins_image = "[img]res://assets/hud/hud-coin.png[/img]"
var outline_prefix="[outline_color=black][outline_size=10]"
var outline_suffix= "[/outline_size][/outline_color]"

func _ready():
	handle_events()

func handle_events():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_CLICKED_SHOP_ITEM, on_purchase_info)

func for_player(_player):
	self.player_wallet = _player.wallet
	coins_left_label.text = coins_image+outline_prefix+" x "+str(player_wallet.coins_nr)+outline_suffix

func on_purchase_info(item: ShopItem):
	show()
	purchased_item = item
	item_name_label.text = tr(purchased_item.item_name)
	item_description_label.text = tr(purchased_item.item_name+"_DESCRIPTION")
	item_price_label.text = tr("CURRENCY_AMOUNT").format({"amount": str(purchased_item.price)})

func _on_cancel_button_pressed():
	clean_up()

# TODO buy with player without worrying about wallet capacity
# TODO disable buy button if user does not have enough coins
# TODO add also check if user can buy so if for some reason user buypass disabled button, it still would not buy
func _on_purchase_button_pressed():
	player_wallet.pay(purchased_item)
	clean_up()

func clean_up():
	purchased_item = null
	hide()

