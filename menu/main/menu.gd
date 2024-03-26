extends Node

signal start_button_pressed

@onready var settings = %Settings
@onready var menu = %Menu
@onready var menu_ui = $UI

func _on_start_pressed():
	emit_signal("start_button_pressed")

func _on_options_pressed():
	settings.show()
	menu.hide()

func back_to_main_menu():
	menu.show()
	settings.hide()

func _on_quit_pressed():
	get_tree().quit()

func hide():
	menu_ui.hide()

func toggle() -> bool:
	menu_ui.visible = !menu_ui.visible 
	if (menu_ui.visible):
		back_to_main_menu()
	return menu_ui.visible
