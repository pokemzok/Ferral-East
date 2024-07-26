class_name Wallet  

var coins_nr = 0
var rare_coins_nr =0

func _init():
	coins_nr = 0
	rare_coins_nr =0

func add(item: Item):
	if (item.get_item_type() == Item.ItemType.COIN):
		coins_nr += 1	
		GlobalEventBus.player_collected_coins.emit(coins_nr)

# FIXME revert after tests
func pay(item: ShopItem):
	#if(coins_nr >= item.price):
	#	coins_nr -= item.price
		GlobalEventBus.player_bought_item.emit(item) 	
