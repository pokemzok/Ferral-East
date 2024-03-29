extends CanvasLayer


func _on_restart_pressed():
	GlobalEventBus.restart_button_pressed.emit()

func _on_menu_pressed():
	GlobalEventBus.quit_to_menu_button_pressed.emit()

func _on_quit_pressed():
	get_tree().quit()
