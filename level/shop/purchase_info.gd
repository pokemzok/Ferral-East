extends Node2D

var purchased_item: ShopItem
var player_wallet

@onready var coins_left_label = %PlayerWalletCoinsLabel
@onready var item_name_label = %ItemNameLabel
@onready var item_price_label = %ItemPriceLabel
@onready var item_description_label = %ItemDescriptionLabel
@onready var purchase_button = %PurchaseButton
var rich_text_behaviour = RichTextCustomBehaviour.get_instance()

var coins_image = "[img]res://assets/hud/hud-coin.png[/img]"

func _ready():
	handle_events()

func handle_events():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_CLICKED_SHOP_ITEM, on_purchase_info)

func handle_buttons():
	if(purchased_item.price > player_wallet.coins_nr):
		purchase_button.disabled = true
	else:
		purchase_button.disabled = false	

func for_player(_player):
	self.player_wallet = _player.wallet
	
func on_purchase_info(item: ShopItem):
	purchased_item = item
	coins_left_label.text = coins_image+rich_text_behaviour.outline_text(" x "+str(player_wallet.coins_nr))
	item_name_label.text = tr(purchased_item.item_name)
	item_description_label.text = tr(purchased_item.item_name+"_DESCRIPTION")
	item_price_label.text = tr("CURRENCY_AMOUNT").format({"amount": str(purchased_item.price)})	
	handle_buttons()
	show()
	
func _on_cancel_button_pressed():
	clean_up()

func _on_purchase_button_pressed():
	player_wallet.pay(purchased_item)
	clean_up()

func clean_up():
	purchased_item = null
	hide()

