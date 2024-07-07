class_name ShopItem
extends Item

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			GlobalEventBus.player_clicked_shop_item.emit(self)
