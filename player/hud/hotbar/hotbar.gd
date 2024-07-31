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
	
	#TODO switching active pocket by clicking E and Q buttons
	#TODO tweek this more later on, i don't want to repeat same item over and over
	#TODO limit item stacks (up to 9 catmints, up to 3 water bottles per stack)
func update_indexes():
	var array_size = player_consumables.size()	
	if (quick_access_pocket_index > array_size-1):
		quick_access_pocket_index = 0

	left_pocket_index = (quick_access_pocket_index - 1 + array_size) % array_size
	right_pocket_index = (quick_access_pocket_index + 1) % array_size

func clear_pockets():
	quick_access_pocket.desactivate()
	quick_access_pocket.put_item(null)
	left_pocket.put_item(null)
	right_pocket.put_item(null)
