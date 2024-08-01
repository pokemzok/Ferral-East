extends HBoxContainer

@onready var left_pocket = $LeftPocket
@onready var right_pocket = $RightPocket
@onready var quick_access_pocket = $QuickAccessPocket

var player_consumables: PlayerInventory
var quick_access_pocket_index: int = 0
var left_pocket_index: int = -1
var right_pocket_index: int = 1

func _ready():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_CONSUMABLES, on_player_consumables)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_CONSUMED_ITEM, on_consumed_item)
	GlobalEventBus.connect(GlobalEventBus.PLAYER_PUT_CONSUMABLE_ITEM_INTO_INVENTORY, on_new_item)

func on_player_consumables(consumables: PlayerInventory):
	player_consumables = consumables
	assign_items_to_pockets()

func on_consumed_item(item):
	assign_items_to_pockets()

func on_new_item(item):
	assign_items_to_pockets()
	
func assign_items_to_pockets():
	if(player_consumables.size() > 0):
		quick_access_pocket.activate()
		update_indexes()
		quick_access_pocket.put_item(player_consumables.get_by_index(quick_access_pocket_index))
		left_pocket.put_item(player_consumables.get_by_index(left_pocket_index))
		right_pocket.put_item(player_consumables.get_by_index(right_pocket_index))
	else:
		clear_pockets()	
	
	#TODO make few consumables to test (convert water bottle to consumable, add stones which just occupy inventory without doing anything)
	#TODO switching active pocket by clicking E and Q buttons
	#TODO tweek this more later on, i don't want to repeat same item over and over
	#TODO weight limit player, so if it by too much it would be hard to move (this way I would not have to divide items by stacks). I can also add some hard limit for items. For most of those it can be 99.
func update_indexes():
	var array_size = player_consumables.size()	
	if (quick_access_pocket_index > array_size-1):
		quick_access_pocket_index = 0
	
	player_consumables.update_quick_access_index(quick_access_pocket_index)
	
	left_pocket_index = (quick_access_pocket_index - 1 + array_size) % array_size
	right_pocket_index = (quick_access_pocket_index + 1) % array_size
	
	if left_pocket_index == quick_access_pocket_index:
		left_pocket_index = quick_access_pocket_index - 1
	if right_pocket_index == quick_access_pocket_index:
		right_pocket_index = quick_access_pocket_index + 1
	if (right_pocket_index == left_pocket_index):
		right_pocket_index = quick_access_pocket_index + 1 if right_pocket_index < quick_access_pocket_index else right_pocket_index
		left_pocket_index = quick_access_pocket_index -1 if left_pocket_index > quick_access_pocket_index else left_pocket_index
		
func clear_pockets():
	quick_access_pocket.desactivate()
	quick_access_pocket.put_item(null)
	left_pocket.put_item(null)
	right_pocket.put_item(null)
