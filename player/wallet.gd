class_name Wallet  

var coins_nr = 0
var rare_coins_nr =0

func _init():
	coins_nr = 0
	rare_coins_nr =0

func apply_item(item: Item):
	if (item.get_item_type() == Item.ItemType.COIN):
		coins_nr += 1	
		GlobalEventBus.player_collected_coins.emit(coins_nr)
