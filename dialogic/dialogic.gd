extends Node

func _ready():
	GlobalEventBus.connect(GlobalEventBus.TRADER_DAMAGED, on_trader_damaged)

func on_trader_damaged(trader_name: String):
	Dialogic.VAR.trader.player_attacking_trader_count += 1
