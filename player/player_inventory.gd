class_name PlayerInventory

var inventory: Dictionary = {}
var hotbar: Array = []

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

func first():
	if (hotbar.size() > 0):
		return inventory[hotbar[0]]
