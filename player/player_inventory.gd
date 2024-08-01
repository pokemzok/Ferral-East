class_name PlayerInventory

var inventory: Dictionary = {}
var hotbar: Array = []
var quick_access_index = 0

enum InsertStatus {
	INSERT,
	INCREMENT
}

func _init():
	GlobalEventBus.connect(GlobalEventBus.PLAYER_CONSUMED_ITEM, on_item_consumed)

func add(item: Item) -> InsertStatus:
	var status = InsertStatus.INSERT
	if (inventory.has(item.id)):
		status = InsertStatus.INCREMENT
		inventory[item.id].increment_quantity()
	else:
		inventory[item.id] = item
		hotbar.append(item.id)

	GlobalEventBus.player_put_consumable_item_into_inventory.emit(inventory[item.id])
	return status
	
func on_item_consumed(item: Item):
	if (item.quantity < 1 && inventory.has(item.id)):
		inventory.erase(item.id)
		remove_from_hotbar(item.id)
		
func remove_from_hotbar(item_id):
	for i in range(hotbar.size()):
		if hotbar[i] == item_id:
			hotbar.erase(hotbar[i])
			return

func size() -> int:
	return hotbar.size()

func get_by_index(index: int):
	if (index < size() && index > -1):
		return inventory[hotbar[index]]

func update_quick_access_index(index: int):
	quick_access_index = index

func get_quick_access_item():
	if (size() > 0):
		return inventory[hotbar[quick_access_index]]
