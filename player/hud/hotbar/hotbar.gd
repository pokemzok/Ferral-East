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

func _process(delta):
	handle_inputs(delta)

func handle_inputs(delta):
	if Input.is_action_just_pressed("rotate_hotbar_left"):
		rotate_quick_access_index(-1)
	if Input.is_action_just_pressed("rotate_hotbar_right"):
		rotate_quick_access_index((1))

func rotate_quick_access_index(increment_value: int):
	var consumables_size = player_consumables.size()
	if (consumables_size > 0):
		quick_access_pocket_index = quick_access_pocket_index + increment_value
		update_indexes()
		assign_items_to_pockets()
	
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
	
func update_indexes():
	var array_size = player_consumables.size()	
	if (quick_access_pocket_index > array_size-1):
		quick_access_pocket_index = 0
	elif (quick_access_pocket_index < 0):
		quick_access_pocket_index = array_size -1 
		
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
