extends Node2D

var puchased_item: ShopItem

func _ready():
	handle_events()

func handle_events():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_CLICKED_SHOP_ITEM, on_purchase_info)

# TODO I need some ideas on how to handle player. Probably need some kind of factory so I can just pass player to the level. That means reworking my current idea. THis way I can add player to shop.
# FIXME item info + wallet information + buttons to buy or cancel
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

