class_name Wallet  

var coins_nr = 0
var rare_coins_nr =0

func _init():
	coins_nr = 39 # FIXME revert to 0
	rare_coins_nr =0

func emit_coins_nr():
	GlobalEventBus.player_collected_coins.emit(coins_nr)

func add(item: Item):
	if (item.is_coin()):
		coins_nr += item.quantity	
		emit_coins_nr()

func pay(item: ShopItem):
	if(coins_nr >= item.price):
		coins_nr -= item.price
		GlobalEventBus.player_bought_item.emit(item)
		emit_coins_nr()
